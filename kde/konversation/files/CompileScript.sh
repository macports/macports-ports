#!/bin/sh -e

  export HOME=/tmp
  export EH_PREFIX="%p"
  . ./environment-helper.sh

#darwinports
  export UNSERMAKE="no"

  export CC=gcc CXX=g++

  ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
  ./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS
  ./build-helper.sh make      %N %v %r make all all_libraries="$ALL_LIBRARIES"
