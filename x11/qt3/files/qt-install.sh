#!/bin/sh -ex

 cd $WORKSRCPATH

 mkdir -p $PREFIX/share/qt3

 perl -pi -e 's,\$\(QTDIR\),$QTDIR,g' lib/*.la

 install -d -m 0755 $PREFIX/bin
 install -c -m 0755 bin/* $PREFIX/bin/

 install -d -m 0755 $PREFIX/lib
 install -c -m 0755 lib/* $PREFIX/lib/

 install -d -m 0755 $PREFIX/lib/qt3-plugins
 /bin/cp -fRL plugins/* $PREFIX/lib/qt3-plugins/

 ln -sf libeditor.1.0.0.dylib $PREFIX/lib/libeditor.1.0.dylib
 ln -sf libeditor.1.0.0.dylib $PREFIX/lib/libeditor.1.dylib
 ln -sf libeditor.1.0.0.dylib $PREFIX/lib/libeditor.dylib

 ln -sf libqt-mt.$VERSION.dylib $PREFIX/lib/libqt-mt.3.3.dylib
 ln -sf libqt-mt.$VERSION.dylib $PREFIX/lib/libqt-mt.3.dylib
 ln -sf libqt-mt.$VERSION.dylib $PREFIX/lib/libqt-mt.dylib

 ln -sf libqui.1.0.0.dylib $PREFIX/lib/libqui.1.0.dylib
 ln -sf libqui.1.0.0.dylib $PREFIX/lib/libqui.1.dylib
 ln -sf libqui.1.0.0.dylib $PREFIX/lib/libqui.dylib

 install -d -m 0755 $PREFIX/lib/pkgconfig
 install -c -m 644  $PREFIX/lib/qt-mt.pc $PREFIX/lib/pkgconfig/

 install -d -m 0755 $PREFIX/share/man/man1
 install -d -m 0755 $PREFIX/share/man/man3
 install -c -m 644  doc/man/man1/* $PREFIX/share/man/man1/
 install -c -m 644  doc/man/man3/* $PREFIX/share/man/man3/

 # clean up the makefiles
 make -C tutorial clean
 make -C examples clean
 perl -pi -e "s,^DEPENDPATH.*,,g;s,^REQUIRES.*,,g" `/usr/bin/find examples -name "*.pro"`
 for a in */*/Makefile ; do
  perl -pi -e 's,^SYSCONF_MOC.*,SYSCONF_MOC             = $QTDIR/bin/moc,' $a
 done

 # install the includes
 for i in include/* include/*/*; do [ -e $i ] || rm -f $i; done
 install -d -m 0755 $PREFIX/include/qt
 /bin/cp -fRL include/* $PREFIX/include/qt/

 # and now the docs
 install -d -m 0755 $PREFIX/share/doc/qt3/html
 install -d -m 0755 $PREFIX/share/doc/qt3/tutorial
 install -d -m 0755 $PREFIX/share/doc/qt3/examples
 /bin/cp -fRL doc/html/* $PREFIX/share/doc/qt3/html/
 /bin/cp -fRL tutorial/* $PREFIX/share/doc/qt3/tutorial/
 /bin/cp -fRL examples/* $PREFIX/share/doc/qt3/examples/

 # the mkspecs
 install -d -m 0755 $PREFIX/share/qt3/mkspecs
 /bin/cp -fRL mkspecs/* $PREFIX/share/qt3/mkspecs/

 # qt designer and linguist templates and phrasebooks
 install -d -m 0755 $PREFIX/share/qt3/templates
 install -d -m 0755 $PREFIX/share/qt3/phrasebooks
 /bin/cp -fRL tools/designer/templates/* $PREFIX/share/qt3/templates/
 /bin/cp -fRL tools/linguist/phrasebooks/* $PREFIX/share/qt3/phrasebooks/

 install -d -m 0755 $PREFIX/share/qt3/translations
 install -c -m 644 `find . -name \*.qm` $PREFIX/share/qt3/translations/

 # kde icon for qt designer
 /bin/mkdir -p $PREFIX/share/applnk/Development
 cat >$PREFIX/share/applnk/Development/designer.desktop <<EOF
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
 cat >$PREFIX/share/applnk/Development/linguist.desktop <<EOF
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
 /bin/rm -rf \
        $PREFIX/lib/README \
        $PREFIX/lib/qt3-plugins/src \
        $PREFIX/lib/*f.prl

 /usr/bin/find $PREFIX/share/doc/qt3 -name \*.moc -print0 | xargs -0 rm -rf {} >/dev/null 2>&1 || :
 /usr/bin/find $PREFIX/share/doc/qt3 -name \*.obj -print0 | xargs -0 rm -rf {} >/dev/null 2>&1 || :
 /usr/bin/find $PREFIX/share/doc/qt3/examples $PREFIX/share/doc/qt3/tutorial -name Makefile -print0 | xargs -0 rm -rf >/dev/null 2>&1 || :
 /usr/bin/find $PREFIX/share/doc/qt3 -name \*.pro -print0 | xargs -0 perl -pi -e 's,^(CONFIG\s*.*)$,$1 thread,' >/dev/null 2>&1 || :
 /usr/bin/find $PREFIX -name \*.bak -print0 | xargs -0 rm -rf >/dev/null 2>&1 || :

 perl -pi -e 's,\$\(QTDIR\),$QTDIR,g' $PREFIX/lib/libqt-mt.la

 install -d -m 755 $PREFIX/share/doc/installed-packages
 touch $PREFIX/share/doc/installed-packages/qt3
 touch $PREFIX/share/doc/installed-packages/qt3-dev

