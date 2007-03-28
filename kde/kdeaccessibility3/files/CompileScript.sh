#!/bin/sh -ev

        export PREFIX="%p" USE_UNSERMAKE=1
        . ./environment-helper.sh
        export ac_cv_path_freetts_bindir="%p/share/java/freetts"

        export DO_NOT_COMPILE="kmouth"

        ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
        ./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS
        ./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS
