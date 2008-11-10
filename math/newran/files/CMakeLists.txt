CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
PROJECT(NEWRAN)
#SET(NEWRAN_SOURCES 
#  extreal.cpp hist.cpp myexcept.cpp newran.cpp tryrand.cpp tryrand1.cpp 
#  tryrand2.cpp tryrand3.cpp tryrand4.cpp tryrand5.cpp)
SET(NEWRAN_SOURCES 
    hist.cpp newran.cpp extreal.cpp myexcept.cpp 
)
SET(TRYRAND_SOURCES
  tryrand.cpp tryrand1.cpp tryrand2.cpp tryrand3.cpp tryrand4.cpp tryrand5.cpp
)

ADD_LIBRARY(newran STATIC ${NEWRAN_SOURCES})
#ADD_EXECUTABLE(tryrand newran ${TRYRAND_SOURCES} )
INSTALL_FILES(/include/newran .*\\.h$)
INSTALL_TARGETS(/lib newran)
