#!/bin/sh

PREFIX="$1"; shift
DESTROOT="$1"; shift
LIBS="libqt-mt.3.dylib libqui.1.dylib"

if [ -z "$PREFIX" ] || [ -z "$DESTROOT" ]; then
	echo "usage: $0 <prefix> <destroot>"
	exit 1
fi

(set -x; install_name_tool -id "/Library/Frameworks/Qt.framework/Qt" "${DESTROOT}/Library/Frameworks/Qt.framework/Qt")

for lib in $LIBS; do
	(set -x; install_name_tool -id "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/lib/${lib}")

	for libchange in $LIBS libcppeditor.dylib libdlgplugin.dylib libgladeplugin.dylib libkdevdlgplugin.dylib librcplugin.dylib libwizards.dylib; do
		if [ -f "${DESTROOT}${PREFIX}/lib/qt3-plugins/designer/${libchange}" ]; then
			(set -x; install_name_tool -change "${lib}" "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/lib/qt3-plugins/designer/${libchange}")
		fi
		if [ -f "${DESTROOT}${PREFIX}/lib/${libchange}" ]; then
			(set -x; install_name_tool -change "${lib}" "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/lib/${libchange}")
		fi
	done

	for app in assistant designer linguist qtconfig lrelease lupdate moc qm2ts qmake uic; do
		if [ -d "${DESTROOT}${PREFIX}/bin/${app}.app" ]; then
			(set -x; install_name_tool -change "${lib}" "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/bin/${app}.app/Contents/MacOS/${app}")
		fi

		if [ -x "${DESTROOT}${PREFIX}/bin/${app}" ]; then
			(set -x; install_name_tool -change "${lib}" "${PREFIX}/lib/${lib}" "${DESTROOT}${PREFIX}/bin/${app}")
		fi
	done
done
