#!/bin/sh

for arg in "$@"; do
	eval "$arg"
done

echo "destroot = ${DESTROOT}"
echo "prefix   = ${PREFIX}"
echo "version  = ${VERSION}"

if test -z "${DESTROOT}" || test -z "${PREFIX}" || test -z "${VERSION}"; then
	exit 1
fi

INCLUDEDIR="${PREFIX}/include/qt3"
PLUGINDIR="${PREFIX}/lib/qt3-plugins"

mkdir -p ${DESTROOT}${PREFIX}/share/qt3
export QTDIR=`pwd`
export DYLD_LIBRARY_PATH="$QTDIR/lib:${PREFIX}/lib:$DYLD_LIBRARY_PATH"
export PATH="$QTDIR/bin:$PATH"

# it appears that make install is a tad broken
install -d -m 0755 ${DESTROOT}${PREFIX}/bin
install -c -m 0755 bin/* ${DESTROOT}${PREFIX}/bin/

install -d -m 0755 ${DESTROOT}${PREFIX}/lib
install -c -m 0755 lib/* ${DESTROOT}${PREFIX}/lib/

install -d -m 0755 ${DESTROOT}${PLUGINDIR}
cp -R plugins/* ${DESTROOT}${PLUGINDIR}

ln -sf libdesigner.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libdesigner.1.0.dylib
ln -sf libdesigner.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libdesigner.1.dylib
ln -sf libdesigner.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libdesigner.dylib

ln -sf libeditor.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libeditor.1.0.dylib
ln -sf libeditor.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libeditor.1.dylib
ln -sf libeditor.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libeditor.dylib

ln -sf libqt-mt.${VERSION}.dylib ${DESTROOT}${PREFIX}/lib/libqt-mt.3.1.dylib
ln -sf libqt-mt.${VERSION}.dylib ${DESTROOT}${PREFIX}/lib/libqt-mt.3.dylib
ln -sf libqt-mt.${VERSION}.dylib ${DESTROOT}${PREFIX}/lib/libqt-mt.dylib

ln -sf libqui.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libqui.1.0.dylib
ln -sf libqui.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libqui.1.dylib
ln -sf libqui.1.0.0.dylib ${DESTROOT}${PREFIX}/lib/libqui.dylib

install -d -m 0755 ${DESTROOT}${PREFIX}/man/man1
install -d -m 0755 ${DESTROOT}${PREFIX}/man/man3
install -c -m 644  doc/man/man1/* ${DESTROOT}${PREFIX}/man/man1/
install -c -m 644  doc/man/man3/* ${DESTROOT}${PREFIX}/man/man3/

# clean up the makefiles
make -C tutorial clean
make -C examples clean
perl -pi -e "s,^DEPENDPATH.*,,g;s,^REQUIRES.*,,g" `find examples -name "*.pro"`
for a in */*/Makefile ; do
 perl -pi -e 's,^SYSCONF_MOC.*,SYSCONF_MOC             = ${PREFIX}/bin/moc,' $a
done

# install the includes
for i in include/* include/*/*; do [ -e $i ] || rm -f $i; done
install -d -m 0755 ${DESTROOT}${INCLUDEDIR}
cp -fRL include/* ${DESTROOT}${INCLUDEDIR}

# and now the docs
install -d -m 0755 ${DESTROOT}${PREFIX}/share/doc/qt3/html
install -d -m 0755 ${DESTROOT}${PREFIX}/share/doc/qt3/tutorial
install -d -m 0755 ${DESTROOT}${PREFIX}/share/doc/qt3/examples
cp -fRL doc/html/* ${DESTROOT}${PREFIX}/share/doc/qt3/html/
cp -fRL tutorial/* ${DESTROOT}${PREFIX}/share/doc/qt3/tutorial/
cp -fRL examples/* ${DESTROOT}${PREFIX}/share/doc/qt3/examples/

# the mkspecs
install -d -m 0755 ${DESTROOT}${PREFIX}/share/qt3/mkspecs
cp -fRL mkspecs/* ${DESTROOT}${PREFIX}/share/qt3/mkspecs/

# qt designer and linguist templates and phrasebooks
install -d -m 0755 ${DESTROOT}${PREFIX}/share/qt3/templates
install -d -m 0755 ${DESTROOT}${PREFIX}/share/qt3/phrasebooks
cp -fRL tools/designer/templates/* ${DESTROOT}${PREFIX}/share/qt3/templates/
cp -fRL tools/linguist/phrasebooks/* ${DESTROOT}${PREFIX}/share/qt3/phrasebooks/

# kde icon for qt designer
mkdir -p ${DESTROOT}${PREFIX}/share/applnk/Development
cat >${DESTROOT}${PREFIX}/share/applnk/Development/designer.desktop <<EOF
[Desktop Entry]
BinaryPattern=designer;
Name=Qt Designer
GenericName=Interface Designer
Exec=designer
Icon=designer
InitialPreference=5
MapNotify=true
MimeType=application/x-designer
Terminal=false
Encoding=UTF-8
Type=Application
EOF
cat >${DESTROOT}${PREFIX}/share/applnk/Development/linguist.desktop <<EOF
[Desktop Entry]
BinaryPattern=linguist;
Name=Qt Linguist
GenericName=Translation Editor
Exec=linguist
Icon=linguist
InitialPreference=5
MapNotify=true
Terminal=false
Encoding=UTF-8
Type=Application
EOF

# remove extra junk
rm -rf \
       ${DESTROOT}${PREFIX}/lib/README \
       ${DESTROOT}${PLUGINDIR}/src \
       ${DESTROOT}${PREFIX}/lib/libqmotif.prl \
       ${DESTROOT}${PLUGINDIR}/accessibleqtwidgets.prl

 find ${DESTROOT}${PREFIX}/share/doc/qt3 -name .moc -exec rm -rf {} \; >/dev/null 2>&1
 find ${DESTROOT}${PREFIX}/share/doc/qt3 -name .obj -exec rm -rf {} \; >/dev/null 2>&1
 find ${DESTROOT}${PREFIX}/share/doc/qt3/examples ${DESTROOT}${PREFIX}/share/doc/qt3/tutorial -name Makefile -exec rm -rf {} \; >/dev/null 2>&1
 find ${DESTROOT}${PREFIX}/share/doc/qt3 -name \*.pro -exec perl -pi -e 's,^(CONFIG\s*.*)$,$1 thread,' {} \; >/dev/null 2>&1

ranlib ${DESTROOT}${PREFIX}/lib/*.a

exit 0
