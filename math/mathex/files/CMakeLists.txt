# modified version of https://src.fedoraproject.org/rpms/mathex/raw/master/f/CMakeLists.txt

# Set  the minimum  required version  of cmake  for a  project.
cmake_minimum_required(VERSION 2.6)
project(MATHEX)

add_library(mathex SHARED mathex.cpp)
set_target_properties(mathex PROPERTIES VERSION 0.3.0 SOVERSION 0)

add_executable(curvetest curvetest.cpp)
add_executable(tabletest tabletest.cpp)
add_executable(userfunctest userfunctest.cpp)
add_executable(inttest inttest.cpp)

link_directories (${MATHEX_BINARY_DIR})
target_link_libraries(curvetest mathex)
target_link_libraries(tabletest mathex)
target_link_libraries(userfunctest mathex)
target_link_libraries(inttest mathex)

install(TARGETS mathex LIBRARY DESTINATION lib${LIB_SUFFIX})
install(FILES mathex.h DESTINATION include)
