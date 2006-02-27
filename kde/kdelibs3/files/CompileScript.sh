#!/bin/sh -e

        export HOME=/tmp PREFIX="%p" QTDOCDIR="%p/share/doc/qt3/html"
        export lt_cv_sys_max_cmd_len=65536
        . ./environment-helper.sh

        PRODUCT_VERSION=`uname -r`

        case $PRODUCT_VERSION in 
                6*|7*)
                        export CPPFLAGS="$CPPFLAGS -DHAVE_SYS_EXEC_H=1"
                        ;; 
        esac

        export CPPFLAGS="-I/usr/include/gssapi $CPPFLAGS"

        export CC=gcc-3.3 CXX=g++-3.3

        ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
        ./build-helper.sh configure %N %v %r ./configure %c
        ./build-helper.sh make      %N %v %r make all all_libraries="$ALL_LIBRARIES"
#apidox#./build-helper.sh apidox    %N %v %r make apidox all_libraries="$ALL_LIBRARIES"
