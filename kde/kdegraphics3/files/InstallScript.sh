#!/bin/sh -e

        export PREFIX="%p"
        . ./environment-helper.sh

        ./build-helper.sh install %N %v %r make -j1 install DESTDIR=%d

        mkdir -p %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N
        touch %i/share/doc/installed-packages/%N-base

        rm -rf %i/share/doc/kde/en/kamera
        rm -rf %i/share/doc/kde/en/kooka
