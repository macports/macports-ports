#!/bin/sh

PREFIX="$1"; shift
DESTROOT="$1"; shift
LIBS="libqt-mt.3.dylib libqui.1.dylib"

if [ -z "$PREFIX" ] || [ -z "$DESTROOT" ]; then
	echo "usage: $0 <prefix> <destroot>"
	exit 1
fi

for lib in $LIBS; do
	install_name_tool -id "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/lib/${lib}"

	for libchange in $LIBS; do
		install_name_tool -change "${lib}" "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/lib/${libchange}"
	done

	for bin in assistant designer linguist qtconfig; do
		install_name_tool -change "${lib}" "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/bin/${bin}.app/Contents/MacOS/${bin}"
	done
done
