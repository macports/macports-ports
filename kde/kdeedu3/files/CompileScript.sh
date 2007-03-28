#!/bin/sh -ev

        export PREFIX="%p" USE_UNSERMAKE=1
        . ./environment-helper.sh
        export LDFLAGS="-L%p/lib/python2.4/config"

        ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
        ./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS
        ./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS kvoctrain/kvoctrain/common-dialogs/prefs.h all
