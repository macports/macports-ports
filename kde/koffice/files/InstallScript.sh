#!/bin/sh -e

  export PREFIX="%p"
  . ./environment-helper.sh

  ./build-helper.sh install %N %v %r make -j1 install DESTDIR=%d all_libraries="$ALL_LIBRARIES" PQXX_INCDIR="%p/include/postgresql"

  mkdir -p %i/share/doc/installed-packages
  touch %i/share/doc/installed-packages/%N
  touch %i/share/doc/installed-packages/%N-base
