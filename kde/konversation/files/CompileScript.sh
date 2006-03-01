#!/bin/sh -e

  export HOME=/tmp
  export EH_PREFIX="%p"
  export EH_USE_CACHE=1
  . ./environment-helper.sh

	export CC=gcc-3.3 CXX=g++-3.3

  ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
  ./build-helper.sh configure %N %v %r ./configure %c
  ./build-helper.sh make      %N %v %r make all all_libraries="$ALL_LIBRARIES"
