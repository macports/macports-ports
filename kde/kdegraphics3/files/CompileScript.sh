#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs

        # MacPorts
        perl -pi.bak -e "s|\`(\\\$PKG_CONFIG --libs \"imlib >= 1.9.10\")\`|\`\1 \| sed \"s/\\\\(-arch\\\\) \\\\([0-9a-zA-Z_]*\\\\)/-Wl,\\\\1,\\\\2/g\"\`|g" configure

	./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS
	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS
