#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install %N %v %r unsermake -p -j1 install DESTDIR=%d

#fink
#	rm -rf %i/share/icons/locolor/16x16/apps/kbabel.png
#	rm -rf %i/share/icons/locolor/32x32/apps/kbabel.png
#macports
	#these icons are provided by kdesdk3
	rm -rf %i/share/icons/Locolor/16x16/apps/kbabel.png
	rm -rf %i/share/icons/Locolor/32x32/apps/kbabel.png
	#
	#these icons are provided by kdeaddons3
	rm -rf %i/share/icons/Locolor/16x16/apps/ktimemon.png
	rm -rf %i/share/icons/Locolor/32x32/apps/ktimemon.png
	#
	#rename "Locolor" to "locolor"
	mv %i/share/icons/Locolor %i/share/icons/locolor.tmp
	mv %i/share/icons/locolor.tmp %i/share/icons/locolor

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N
	touch %i/share/doc/installed-packages/%N-base
