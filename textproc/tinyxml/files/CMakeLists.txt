project(TinyXML CXX)

add_definitions(-DTIXML_USE_STL)
add_library(tinyxml SHARED tinystr.cpp tinyxml.cpp tinyxmlerror.cpp tinyxmlparser.cpp)
install(TARGETS tinyxml LIBRARY DESTINATION lib)
install(FILES tinystr.h tinyxml.h DESTINATION include)