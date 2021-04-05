
# make a subdirectory for generated header files related to the blas interface library
file(MAKE_DIRECTORY ${MTP_GENERATED_INC_DIR}/mtp/blas_interface)

# configure the header file that helps us connect to whichever external blas we are using
configure_file(setup.h.in ${MTP_GENERATED_INC_DIR}/mtp/blas_interface/setup.h)

# get a list of all .cpp files in this directory
file(GLOB CPP_FILES_FOR_THIS_THING
     *.cpp
)

message(STATUS "The mtp_blas_interface library combines the following files:")
foreach(F ${CPP_FILES_FOR_THIS_THING})
    message(STATUS "     ${F}")
endforeach()

# tell cmake to build a library using the cpp files we found
add_library(mtp_blas_interface SHARED ${CPP_FILES_FOR_THIS_THING})

# Tell cmake that anything that links to this library also needs to link to the BLAS library
# that we found using find_package(BLAS...)
target_link_libraries(mtp_blas_interface ${BLAS_LIBRARIES})

# Tell cmake that the install step should include this library in its install
install(TARGETS mtp_blas_interface)
