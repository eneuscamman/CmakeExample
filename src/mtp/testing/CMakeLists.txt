
set(MTP_TESTING_WORKING_DIR ${CMAKE_CURRENT_BINARY_DIR}/testing)

file(MAKE_DIRECTORY ${MTP_TESTING_WORKING_DIR})

# tell cmake to build the test executable
add_executable(test_dot_exe test_dot.cpp)

# tell cmake that this executable needs to link to our blas interface library
target_link_libraries(test_dot_exe mtp_blas_interface)

# add the test to the cmake testing system
add_test(NAME test_dot
         COMMAND test_dot_exe
         WORKING_DIRECTORY ${MTP_TESTING_WORKING_DIR}
)
