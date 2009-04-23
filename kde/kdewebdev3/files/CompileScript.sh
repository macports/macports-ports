#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
	./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS

	perl -pi -e 's,-fvisibility=hidden -fvisibility-inlines-hidden,,g' Makefile

	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS
