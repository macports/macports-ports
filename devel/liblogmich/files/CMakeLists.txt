cmake_minimum_required(VERSION 3.6)

# supress rpath warning
cmake_policy(SET CMP0042 OLD)

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++1y" COMPILER_SUPPORTS_CXX1y)
if(COMPILER_SUPPORTS_CXX1y)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
else()
        message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++1y support. Please use a different C++ compiler.")
endif()

include_directories(include)
add_library(logmich SHARED src/log.cpp src/logger.cpp )


install (TARGETS logmich DESTINATION lib)
install (FILES include/logmich/log.hpp include/logmich/logger.hpp DESTINATION include/logmich/)

if (OPTION_INSTALL_TEST_APP)
    add_executable(logmich-test tests/main.cpp)
    target_link_libraries(logmich-test logmich)
    install (TARGETS logmich-test DESTINATION bin)
endif()