#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install        %N %v %r unsermake -p -j1 install DESTDIR=%d
#apidox#./build-helper.sh install-apidox %N %v %r unsermake -p -j1 install-apidox DESTDIR=%d

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N

	touch %i/share/doc/installed-packages/kdebase3
	touch %i/share/doc/installed-packages/kdebase3-shlibs
	touch %i/share/doc/installed-packages/kdebase3-dev
	touch %i/share/doc/installed-packages/kdebase3-ssl
	touch %i/share/doc/installed-packages/kdebase3-ssl-shlibs
	touch %i/share/doc/installed-packages/kdebase3-ssl-dev

	install -d -m 755 %i/etc/pam.d
	install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kde
	install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kdm
	install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kcheckpass
	install -c -m 444 /etc/pam.d/login %i/etc/pam.d/kscreensaver
	rm -rf %i/share/icons/crystalsvg/scalable/apps/artsbuilder.*

	install -d -m 755 "%d`%p/bin/xfontpath basedir`"
#fink
#	mv "%i/share/apps/konsole/fonts" "%d`%p/bin/xfontpath basedir`/konsole"
#macports
	mv "%i/share/apps/konsole/fonts" "%d%p/share/fonts/konsole"
