#!/bin/sh -e

  export PREFIX="%p"
  . ./environment-helper.sh

  ./build-helper.sh install %N %v %r unsermake install DESTDIR="%d"

  mkdir -p %i/share/doc/installed-packages
  touch %i/share/doc/installed-packages/%N
  touch %i/share/doc/installed-packages/%N-base
