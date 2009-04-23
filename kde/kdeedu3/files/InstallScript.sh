#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install %N %v %r unsermake -p -j1 install DESTDIR=%d

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N
	touch %i/share/doc/installed-packages/%N-base

	# FIXME: this works around an initialization error in kstars, this should
	# get fixed for real!
	install -d -m 755 %i/share/config
	touch %i/share/config/kstarsrc

	# they changed the library name, but not the compat version??
	pushd %i/lib
	ln -s libkdeeduui.3.dylib libkdeeduui.1.dylib
	popd

	pushd %b; FixifiedB=`/bin/pwd`; popd
	perl -pi -e "s,-L$FixifiedB,-L%p,g" %i/lib/*.la %i/lib/kde3/*.la
