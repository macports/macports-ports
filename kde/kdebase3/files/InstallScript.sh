#!/bin/sh -e

        export HOME=/tmp PREFIX="%p" QTDOCDIR="%p/share/doc/qt3/html"
        . ./environment-helper.sh

        ./build-helper.sh install        %N %v %r make -j1 install DESTDIR=%d
#apidox#./build-helper.sh install-apidox %N %v %r make -j1 install-apidox install-apidox-recurse DESTDIR=%d

        mkdir -p %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N

        touch %i/share/doc/installed-packages/kdebase3
        touch %i/share/doc/installed-packages/kdebase3-shlibs
        touch %i/share/doc/installed-packages/kdebase3-dev
        touch %i/share/doc/installed-packages/kdebase3-ssl
        touch %i/share/doc/installed-packages/kdebase3-ssl-shlibs
        touch %i/share/doc/installed-packages/kdebase3-ssl-dev

        install -d -m 755 %i/etc/pam.d
        install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kde
        install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kdm
        install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kcheckpass
        install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kscreensaver
        rm -rf %i/share/fonts || true
        rm -rf %i/share/icons/crystalsvg/scalable/apps/artsbuilder.*

#fink
#       ./build-helper.sh konsole-install %N %v %r make -C konsole/fonts install fontdir=`%p/bin/xfontpath basedir`/konsole DESTDIR=%d
#darwinports
        ./build-helper.sh konsole-install %N %v %r make -C konsole/fonts install fontdir=%p/share/fonts/konsole DESTDIR=%d
