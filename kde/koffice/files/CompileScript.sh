#!/bin/sh -e

  export HOME=/tmp
  export PREFIX="%p"
  . ./environment-helper.sh
  export lt_cv_sys_max_cmd_len=65536

  export CC=gcc-3.3 CXX=g++-3.3

  ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
  ./build-helper.sh configure %N %v %r ./configure %c
  ./build-helper.sh make      %N %v %r make all all_libraries="$ALL_LIBRARIES" PQXX_INCDIR="%p/include/postgresql"
