CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
PROJECT(NEWRAN)
#SET(NEWRAN_SOURCES 
#  extreal.cpp hist.cpp myexcept.cpp newran.cpp tryrand.cpp tryrand1.cpp 
#  tryrand2.cpp tryrand3.cpp tryrand4.cpp tryrand5.cpp)
SET(NEWRAN_SOURCES 
    newran1.cpp newran2.cpp myexcept.cpp simpstr.cpp extreal.cpp
)
SET(TRYRAND_SOURCES
    tryrand.cpp format.cpp utility.cpp tryrand1.cpp tryrand2.cpp tryrand3.cpp tryrand4.cpp tryrand5.cpp tryrand6.cpp str.cpp test_out.cpp
)

ADD_LIBRARY(newran STATIC ${NEWRAN_SOURCES})
#ADD_EXECUTABLE(tryrand newran ${TRYRAND_SOURCES} )
INSTALL_FILES(/include/newran .*\\.h$)
INSTALL_TARGETS(/lib newran)
