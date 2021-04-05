
# get a list of all .cpp files in this directory
file(GLOB CPP_FILES_FOR_THIS_THING
     *.cpp
)

message(STATUS "The dotter executable is made from the following cpp files:")
foreach(F ${CPP_FILES_FOR_THIS_THING})
    message(STATUS "     ${F}")
endforeach()

# tell cmake to build the executable
add_executable(dotter ${CPP_FILES_FOR_THIS_THING})

# tell cmake that this executable needs to link to our blas interface library
target_link_libraries(dotter mtp_blas_interface)

# Tell cmake that the install step should include this executable in its install
install(TARGETS dotter)
