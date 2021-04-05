# Set the minimum version of cmake that is required for the build
cmake_minimum_required(VERSION 3.12)

# Initiate the project and tell cmake what languages are involved
project(mytestproject
        LANGUAGES CXX
)

# Tell cmake to set compiler flags as needed for C++11 and to ensure
# that the compiler is capable of handling C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Tell cmake to have find_package pay attention to <PackageName>_ROOT
cmake_policy(SET CMP0074 NEW)

# Tell cmake to handle the testing that will happen when we run "make test"
enable_testing()

# Python handling
include(CMakeStuff/python_handling.cmake)

# BLAS handling
include(CMakeStuff/blas_handling.cmake)

# RPATH handling
include(CMakeStuff/rpath_handling.cmake)

# Set up some additional compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -fPIC")

# prepare directory in build tree where we will put configured header files
set(MTP_GENERATED_INC_DIR ${CMAKE_CURRENT_BINARY_DIR}/mtp_generated_includes)
file(MAKE_DIRECTORY ${MTP_GENERATED_INC_DIR})
file(MAKE_DIRECTORY ${MTP_GENERATED_INC_DIR}/mtp)

# specify some directories that we want the compiler to include headers from
include_directories(${CMAKE_SOURCE_DIR}/src
                    ${MTP_GENERATED_INC_DIR}
)

# go to the subdirectories to finish the cmake setup there
add_subdirectory(src/mtp/blas_interface)
add_subdirectory(src/mtp/dotter)
add_subdirectory(src/mtp/testing)
