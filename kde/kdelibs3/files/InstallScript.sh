#!/bin/sh -e

        export HOME=/tmp PREFIX="%p" QTDOCDIR="%p/share/doc/qt3/html"
        . ./environment-helper.sh

        ./build-helper.sh install        %N %v %r make -j1 install DESTDIR=%d
#apidox#./build-helper.sh install-apidox %N %v %r make -j1 install-apidox install-apidox-recurse DESTDIR=%d

	#fink
        #rm -rf %i/share/icons/hicolor/index.theme
	#darwinports
	#

        install -c -m 644 darwin/* %i/share/config

        mkdir -p %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N

        touch %i/share/doc/installed-packages/kdelibs3
        touch %i/share/doc/installed-packages/kdelibs3-shlibs
        touch %i/share/doc/installed-packages/kdelibs3-dev
        touch %i/share/doc/installed-packages/kdelibs3-ssl
        touch %i/share/doc/installed-packages/kdelibs3-ssl-shlibs
        touch %i/share/doc/installed-packages/kdelibs3-ssl-dev
