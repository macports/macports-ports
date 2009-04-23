#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install %N %v %r unsermake -p -j1 install DESTDIR=%d

#fink
#	# in kdeartwork now
#	rm -rf %i/share/icons/locolor/16x16/apps/ktimemon.png
#	rm -rf %i/share/icons/locolor/32x32/apps/ktimemon.png
#macports
#

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N
	touch %i/share/doc/installed-packages/%N-base
