#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh
	export ac_cv_path_GPGME_CONFIG="%p/bin/gpgme-config --thread=pthread"

	export CC=gcc CXX=g++

	./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
	./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS

#  perl -pi -e 's,yytext_ptr,libical_ptr,g' libical/src/libical/icallexer.c
#  perl -pi -e 's,yytext_ptr,libicalss_ptr,g' libical/src/libicalss/icalsslexer.c
#  perl -pi -e 's, holidays , ,g' korganizer/plugins/Makefile

	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS
