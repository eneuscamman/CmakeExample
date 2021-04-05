
###################################################################################
### Here we try to find BLAS and if necessary figure out some things about it   ###
###################################################################################

# Initialize the variable that tells cmake which type of BLAS we are looking for.
# This gets overwritten by the user input if it is specified on the command line (e.g. with -D BLA_VENDOR=Generic)
set(BLA_VENDOR ""
    CACHE STRING "Specifies a specific type of BLAS library to look for.  See CMake FindBLAS documentation for possibilities."
)

# Initialize the root directory of the BLAS installation we will look for.
# This can also be initialized to something else by the user on the command line.
set(BLAS_ROOT ""
    CACHE PATH "Specifies the installation directory in which to look for the BLAS library."
)

# Initialize the root directory for MKL.
# This can also be initialized to something else by the user on the command line.
set(MKL_ROOT ""
    CACHE PATH "Specifies the installation directory in which to look for MKL."
)

# If we don't have the MKL root directory, check to see if it is specified by an environment variable.
if (NOT MKL_ROOT)
  if (DEFINED ENV{MKLROOT})
    set(MKL_ROOT "$ENV{MKLROOT}")
  elseif (DEFINED ENV{MKL_ROOT})
    set(MKL_ROOT "$ENV{MKL_ROOT}")
  endif()
endif()

# If we still don't have a specification for the BLAS installation's root directory but
# we do have the corresponding MKL directory, use the MKL directory.
if(NOT BLAS_ROOT)
  if (MKL_ROOT)
    set(BLAS_ROOT ${MKL_ROOT})
  endif (MKL_ROOT)
endif(NOT BLAS_ROOT)

# If a BLAS vendor has not been specified, choose one.
if(NOT BLA_VENDOR)
  if (MKL_ROOT) # prefer MKL if we can get it
    set(BLA_VENDOR "Intel10_64lp")
  elseif(APPLE) # otherwise, if on macOS, use Apple's BLAS
    set(BLA_VENDOR "Apple")
  else() # otherwise default to searching for a generic BLAS library
    set(BLA_VENDOR "Generic")
  endif()
endif()

# Set variables that will be used in configuring the BLAS setup header file.
set(MTP_HAVE_BLAS_MACOS   FALSE)
set(MTP_HAVE_BLAS_MKL     FALSE)
set(MTP_HAVE_BLAS_GENERIC FALSE)
if(${BLA_VENDOR} MATCHES "Apple")
  set(MTP_HAVE_BLAS_MACOS TRUE)
elseif(${BLA_VENDOR} MATCHES "Intel10_64lp")
  set(MTP_HAVE_BLAS_MKL TRUE)
elseif(${BLA_VENDOR} MATCHES "Generic")
  set(MTP_HAVE_BLAS_GENERIC TRUE)
else()
  message(FATAL_ERROR "ended up with unexpected BLAS vendor request:  BLA_VENDOR=${BLA_VENDOR}")
endif()

# Now that we've got the key pieces set up (specifically BLA_VENDOR and BLAS_ROOT)
# we tell cmake to go find BLAS and print out the results.
# The required tag makes it so that cmake will die with an error if BLAS is not found.
message(STATUS "Searching for BLAS with BLA_VENDOR=${BLA_VENDOR}")
find_package(BLAS
             REQUIRED
)
message(STATUS "BLAS_FOUND = ${BLAS_FOUND}")
message(STATUS "BLAS_LINKER_FLAGS = ${BLAS_LINKER_FLAGS}")
message(STATUS "BLAS_LIBRARIES = ${BLAS_LIBRARIES}")

# if using Apple Accelerate, find the Accelerate.h header file
if(MTP_HAVE_BLAS_MACOS)
  find_path(MTP_MACOS_BLAS_INC_DIR Accelerate.h
            PATHS ${BLAS_LIBRARIES}/Headers
            REQUIRED
            NO_DEFAULT_PATH
  )
  set(MTP_APPLE_ACCELERATE_HEADER ${MTP_MACOS_BLAS_INC_DIR}/Accelerate.h)
endif()

# if using MKL, find the mkl.h header file
if(MTP_HAVE_BLAS_MKL)
  find_path(MTP_MKL_INC_DIR mkl.h
            PATHS ${BLAS_ROOT}/include
            REQUIRED
            NO_DEFAULT_PATH
           )
  set(MTP_MKL_HEADER ${MTP_MKL_INC_DIR}/mkl.h)
endif()

# set a variable that tells whether or not cblas is available
set(MTP_HAVE_CBLAS NO)
if(MTP_HAVE_BLAS_MACOS OR MTP_HAVE_BLAS_MKL)
  set(MTP_HAVE_CBLAS YES)
endif()

# if using Generic blas, figure out the name mangling
include(CheckLibraryExists)
if(MTP_HAVE_BLAS_GENERIC)
    foreach(D ${BLAS_LIBRARIES})
        if(NOT MTP_GENERIC_BLAS_LIB_DIR)  
            get_filename_component(MTP_GENERIC_BLAS_LIB_DIR ${D} DIRECTORY)
        endif()
    endforeach()
    message(STATUS "MTP_GENERIC_BLAS_LIB_DIR=${MTP_GENERIC_BLAS_LIB_DIR}")
    CHECK_LIBRARY_EXISTS(blas sgemm  ${MTP_GENERIC_BLAS_LIB_DIR} MTP_BLAS_MANGLE_UNDERSCORE_NONE)
    if(NOT MTP_BLAS_MANGLE_UNDERSCORE_NONE)
        CHECK_LIBRARY_EXISTS(blas _sgemm ${MTP_GENERIC_BLAS_LIB_DIR} MTP_BLAS_MANGLE_UNDERSCORE_BEFORE)
        if(NOT MTP_BLAS_MANGLE_UNDERSCORE_BEFORE)
            CHECK_LIBRARY_EXISTS(blas sgemm_ ${MTP_GENERIC_BLAS_LIB_DIR} MTP_BLAS_MANGLE_UNDERSCORE_AFTER)
            if(NOT MTP_BLAS_MANGLE_UNDERSCORE_AFTER)
                message(FATAL_ERROR "Could not determine name mangling for Generic BLAS")
            endif()
        endif()
    endif()
endif()
