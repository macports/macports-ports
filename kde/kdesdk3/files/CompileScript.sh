#!/bin/sh -e

        export HOME=/tmp
        export PREFIX="%p"
	#fink
        #export LEX="%p/lib/flex/bin/flex"
        #darwinports
        export LEX="%p/bin/flex"
        . ./environment-helper.sh
        export lt_cv_sys_max_cmd_len=65536

        export CC=gcc-3.3 CXX=g++-3.3

        ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
        ./build-helper.sh configure %N %v %r ./configure %c

        perl -pi -e 's,(..libdir.)/kde3,$1,g' kompare/libdialogpages/Makefile
        find . -name \*.l -exec touch {} \;
        find . -name \*.ll -exec touch {} \;

        ./build-helper.sh make      %N %v %r make all LIB_DBIV=-ldb-4.2 all_libraries="$ALL_LIBRARIES"
