#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
	./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS

	perl -pi -e 's,(..libdir.)/kde3,$1,g' kompare/libdialogpages/Makefile
	find . -name \*.l -exec touch {} \;
	find . -name \*.ll -exec touch {} \;

#fink
#	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS LIB_DBIV=-ldb-4.2
#macports
	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS LIB_DBIV=-ldb-4.6
