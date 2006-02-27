#!/bin/sh -e

        export HOME=/tmp PREFIX="%p" QTDOCDIR="%p/share/doc/qt3/html"
        . ./environment-helper.sh
        export lt_cv_sys_max_cmd_len=65536

        export CC=gcc-3.3 CXX=g++-3.3

        export PKG_CONFIG_PATH="%p/lib/fontconfig2/lib/pkgconfig:%p/lib/freetype219/lib/pkgconfig:$PKG_CONFIG_PATH"

        case $SW_VERSION in
                10.[0123])
                        perl -pi -e 's,FONTINST_SUBDIR="kfontinst",FONTINST_SUBDIR="",' kcontrol/kfontinst/configure.in.in
                        ;;
        esac

        ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
        ./build-helper.sh configure %N %v %r ./configure %c
        ./build-helper.sh make      %N %v %r make all all_libraries="$ALL_LIBRARIES" KDM_FLAGS="-UHAVE_UTMPX -DBSD_UTMP=1"
#apidox#./build-helper.sh apidox    %N %v %r make apidox
