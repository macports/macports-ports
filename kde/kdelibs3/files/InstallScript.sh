#!/bin/sh -ev

	export PREFIX="%p" USE_UNSERMAKE=1
	. ./environment-helper.sh

	./build-helper.sh install        %N %v %r unsermake -p -j1 install DESTDIR=%d
#apidox#./build-helper.sh install-apidox %N %v %r unsermake -p -j1 install-apidox DESTDIR=%d

#fink
#	cat <<END >%i/bin/kde-update-caches.sh
##!/bin/sh
#
#	if [ \`id -un\` != 'root' ]; then
#		echo "you must run this script as root!"
#		echo ""
#		exit 1
#	fi
#
#	ENV="env KDEDIR= KDEDIRS= HOME=/tmp XDG_CACHE_HOME=/tmp/kb/cache XDG_CONFIG_HOME=/tmp/kb/config XDG_DATA_HOME=/tmp/kb/share HISTFILE=/tmp/kb/.bash_history USER=root LOGNAME=root"
#	\$ENV %p/bin/update-mime-database %p/share/mime
#	\$ENV %p/bin/kbuildsycoca --global --noincremental --nosignal
#END
#	chmod 755 %i/bin/kde-update-caches.sh
#macports
#

	rm -rf %i/share/icons/hicolor/index.theme

	install -c -m 644 darwin/* %i/share/config

	mkdir -p %i/share/doc/installed-packages
	touch %i/share/doc/installed-packages/%N

	touch %i/share/doc/installed-packages/kdelibs3
	touch %i/share/doc/installed-packages/kdelibs3-shlibs
	touch %i/share/doc/installed-packages/kdelibs3-dev
	touch %i/share/doc/installed-packages/kdelibs3-ssl
	touch %i/share/doc/installed-packages/kdelibs3-ssl-shlibs
	touch %i/share/doc/installed-packages/kdelibs3-ssl-dev
