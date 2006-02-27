#!/bin/sh -e

        export HOME=/tmp PREFIX="%p" QTDOCDIR="%p/share/doc/qt3/html"
        . ./environment-helper.sh

        ./build-helper.sh install %N %v %r make -j1 install DESTDIR=%d

        mkdir -p %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N
        touch %i/share/doc/installed-packages/%N-base
