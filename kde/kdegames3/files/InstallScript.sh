#!/bin/sh -e

        export PREFIX="%p"
        . ./environment-helper.sh

#unsermake
	export UNSERMAKE="no"

        ./build-helper.sh install %N %v %r make -j1 install DESTDIR=%d

        mkdir -p %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N
        touch %i/share/doc/installed-packages/%N-base
