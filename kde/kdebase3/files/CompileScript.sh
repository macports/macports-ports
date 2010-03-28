#!/bin/sh -ev

	if [ `id -un` != "root" ]; then
		echo "you must be root to build this package, it creates setuid binaries!"
		exit 1
	fi

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	perl -pi -e 's,FONTINST_SUBDIR="kfontinst",FONTINST_SUBDIR="",' kcontrol/kfontinst/configure.in.in

	./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
	./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS
	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS KDM_FLAGS="-UHAVE_UTMPX -DBSD_UTMP=1"
#apidox#./build-helper.sh apidox    %N %v %r unsermake $UNSERMAKEFLAGS apidox
