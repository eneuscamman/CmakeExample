
# try to find the python3 executable
find_program(Python_EXECUTABLE
             NAMES python3
)

# if we can't find python3, find python instead
if(NOT Python_EXECUTABLE)
  find_program(Python_EXECUTABLE
               NAMES python
  )
endif()

# if we found neither, then we're stuck
if(NOT Python_EXECUTABLE)
  message(FATAL_ERROR "Failed to find python3 or python")
endif()

# check whether we are in a python virtual environment
execute_process(COMMAND ${Python_EXECUTABLE} ${CMAKE_SOURCE_DIR}/CMakeStuff/python_virtualenv_checker.py
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/python_virtualenv_check.txt
                COMMAND_ERROR_IS_FATAL ANY
)
file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/python_virtualenv_check.txt MTP_WE_ARE_IN_A_PYTHON_VIRTUALENV LIMIT_COUNT 1)
message(STATUS "Are we in a python virtual environment? ${MTP_WE_ARE_IN_A_PYTHON_VIRTUALENV}")

# if we are in a python virtual environment, tell cmake to ignore other pythons that might be present
if(MTP_WE_ARE_IN_A_PYTHON_VIRTUALENV)
  set(Python_FIND_VIRTUALENV "ONLY")
endif()

# Find various components of the python installation.
# Note we unset Python_EXECUTABLE so that cmake can set it anew based on what it finds.
unset(Python_EXECUTABLE)
find_package(Python COMPONENTS Interpreter Development)

# print out some info on what we found
message(STATUS "Python_EXECUTABLE = ${Python_EXECUTABLE}")
message(STATUS "Python_STDLIB = ${Python_STDLIB}")
message(STATUS "Python_INCLUDE_DIRS = ${Python_INCLUDE_DIRS}")
message(STATUS "Python_LIBRARIES = ${Python_LIBRARIES}")
message(STATUS "Python_LIBRARY_DIRS = ${Python_LIBRARY_DIRS}")
message(STATUS "Python_RUNTIME_LIBRARY_DIRS = ${Python_RUNTIME_LIBRARY_DIRS}")
message(STATUS "Python_VERSION = ${Python_VERSION}")
message(STATUS "Python_VERSION_MAJOR = ${Python_VERSION_MAJOR}")
message(STATUS "Python_VERSION_MINOR = ${Python_VERSION_MINOR}")
message(STATUS "Python_VERSION_PATCH = ${Python_VERSION_PATCH}")

