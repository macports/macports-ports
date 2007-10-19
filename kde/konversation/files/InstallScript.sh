#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install %N %v %r unsermake -p -j1 install DESTDIR=%d LN_S='ln -sf'

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N
