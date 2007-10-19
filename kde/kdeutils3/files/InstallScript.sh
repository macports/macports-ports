#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install %N %v %r unsermake -p -j1 install DESTDIR=%d kgpg_SUBDIR_included_TRUE='#' kgpg_SUBDIR_included_FALSE=

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N
	touch %i/share/doc/installed-packages/%N-base

	find %i -name \*kmilo\* -exec rm -rf {} \; || :
	find %i -name \*irkick\* -exec rm -rf {} \; || :
	find %i -name \*kcmlirc\* -exec rm -rf {} \; || :
	rm -rf %i/share/applications/kde/pcmcia.desktop
	rm -rf %i/share/applications/kde/thinkpad.desktop
	rm -rf %i/share/apps/profiles
	rm -rf %i/share/apps/remotes
	find %i -name \*kgpg\* -exec rm -rf {} \; || :
