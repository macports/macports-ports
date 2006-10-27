#!/bin/sh -e

        export PREFIX="%p" USE_UNSERMAKE=1
        . ./environment-helper.sh

        ./build-helper.sh install %N %v %r unsermake -p -j1 install DESTDIR=%d LN_S='ln -sf'

        [ -f %i/share/services/irc.protocol  ] && mv %i/share/services/irc.protocol  %i/share/services/konvirc.protocol
        [ -f %i/share/services/irc6.protocol ] && mv %i/share/services/irc6.protocol %i/share/services/konvirc6.protocol

        mkdir -p %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N
