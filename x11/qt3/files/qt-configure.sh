#!/bin/sh

FILEPREFIX=`dirname $0`
PUREDARWIN="false"
ARGS=""

for ARG in "$@"; do
	if test "$ARG" = "-puredarwin"; then
		PUREDARWIN="true"
	else
		ARGS="$ARGS $ARG"
	fi
done

DARWIN_PATCHES=" \
	patch-01-xft2.darwin \
	patch-02-qglobal.puredarwin \
	patch-04-libname.darwin \
	patch-05-compat_version.darwin \
	patch-06-librarysearch.darwin \
	patch-07-nonstatic.darwin \
"
MACOSX_PATCHES=" \
	patch-01-xft2.darwin \
	patch-02-qglobal.macosx \
	patch-03-cf.macosx \
	patch-04-libname.darwin \
	patch-05-compat_version.darwin \
	patch-06-librarysearch.darwin \
	patch-07-nonstatic.darwin \
	patch-08-macdefines.macosx \
"

CONFIGURE="-I'${worksrcpath}/include' -I'${prefix}/include' \
		-I'/usr/X11R6/include/freetype2' -I'${prefix}/include/cups' -L'${prefix}/lib' \
		-prefix '${prefix}' -bindir '${prefix}/bin' -libdir '${prefix}/lib' \
		-docdir '${prefix}/share/doc/${portname}/html' -datadir '${prefix}/share/qt3' \
                -headerdir '${prefix}/include/qt3' -plugindir '${prefix}/lib/qt3-plugins' \
                -release -shared -fast -no-exceptions -thread -stl -qt-gif -plugin-imgfmt-png \
                -plugin-imgfmt-jpeg -plugin-imgfmt-mng -system-libpng -system-libjpeg \
                -system-zlib -largefile -sm -xinerama -xrender -xft -xkb \
"

if test "$PUREDARWIN" = "false"; then
	for FRAMEWORK in Carbon CoreServices; do
		if test ! -f /System/Library/Frameworks/${FRAMEWORK}.framework/Headers/${FRAMEWORK}.h; then
			echo "you have not specified the pure darwin variant, but you are missing the ${FRAMEWORK} framework!"
			exit 1
		fi
	done
fi

if test "$PUREDARWIN" = "true"; then
	echo "- using puredarwin configuration"
	for patch in ${DARWIN_PATCHES}; do
		echo "- applying ${patch}:"
		sed -e "s#@PREFIX@#${prefix}#g" "${FILEPREFIX}/$patch" | patch -p0 | while read LINE; do
			echo "    $LINE"
		done
	done

	echo "- setting up qmake.conf"
	sed -e "s#@PREFIX@#${prefix}#g" "${FILEPREFIX}/qmake.conf.puredarwin" > "mkspecs/darwin-g++/qmake.conf"

	echo "- running configure"
	echo yes | sh ./configure $CONFIGURE -buildkey qt3-darwin -platform darwin-g++ -xplatform darwin-g++ $ARGS
else
	echo "- using MacOSX configuration"
	for patch in ${MACOSX_PATCHES}; do
		echo "- applying ${patch}:"
		sed -e "s#@PREFIX@#${prefix}#g" "${FILEPREFIX}/$patch" | patch -p0 | while read LINE; do
			echo "    $LINE"
		done
	done

	echo "- setting up qmake.conf"
	sed -e "s#@PREFIX@#${prefix}#g" "${FILEPREFIX}/qmake.conf.macosx" > "mkspecs/darwin-g++/qmake.conf"

	echo "- running configure"
	echo yes | sh ./configure $CONFIGURE -buildkey qt3-jaguar -platform darwin-g++ -xplatform darwin-g++ -DQ_OS_DARWIN -DQ_OS_FREEBSD $ARGS
fi

