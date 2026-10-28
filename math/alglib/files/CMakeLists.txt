# modified version of https://src.fedoraproject.org/rpms/alglib/raw/rawhide/f/CMakeLists.txt

# Set  the minimum  required version  of cmake  for a  project.
cmake_minimum_required(VERSION 2.6)

set(ALGLIB_VERSION "" CACHE STRING "The package version")
set(ALGLIB_VERSION_MAJOR "" CACHE STRING "The package major version")

file(GLOB_RECURSE HDR RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/*.h)
file(GLOB_RECURSE SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/*.cpp)

add_library(alglib SHARED ${SRC})
set_target_properties(alglib PROPERTIES VERSION ${ALGLIB_VERSION} SOVERSION ${ALGLIB_VERSION_MAJOR})

add_executable(test_c tests/test_c.cpp)
add_executable(test_i tests/test_i.cpp)
add_executable(test_x tests/test_x.cpp)
set_target_properties(test_c PROPERTIES COMPILE_FLAGS "-DAE_USE_ALLOC_COUNTER -DAE_DEBUG4POSIX")
set_target_properties(test_i PROPERTIES COMPILE_FLAGS "-DAE_USE_ALLOC_COUNTER -DAE_DEBUG4POSIX")
set_target_properties(test_x PROPERTIES COMPILE_FLAGS "-DAE_USE_ALLOC_COUNTER -DAE_DEBUG4POSIX")
include_directories(src/)
target_link_libraries(test_c alglib)
target_link_libraries(test_i alglib)
target_link_libraries(test_x alglib)

install(TARGETS alglib LIBRARY DESTINATION lib${LIB_SUFFIX})
install(FILES ${HDR} DESTINATION include/libalglib)

# DPorts installs headers in include/libalglib.
# See https://github.com/DragonFlyBSD/DPorts/blob/master/math/alglib/pkg-plist
#
# Fedora and Homebrew install headers in include/alglib.
# See https://packages.fedoraproject.org/pkgs/alglib/alglib-devel/fedora-rawhide.html#files
# See https://github.com/brewsci/homebrew-science/blob/master/Formula/alglib.rb
#
# Gentoo seems to install headers in include.
# See https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/alglib/files/CMakeLists.txt-3.8.2
#
# Gmsh expects headers in include/libalglib, so use that.


enable_testing()
add_test( test_c ${CMAKE_BUILD_DIR}/test_c)
add_test( test_i ${CMAKE_BUILD_DIR}/test_i)
add_test( test_x ${CMAKE_BUILD_DIR}/test_x)
