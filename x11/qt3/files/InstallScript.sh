#!/bin/sh -ex

        #### MAIN INSTALL ####

        unset QMAKESPEC
        export QTDIR=`pwd`
        export DYLD_LIBRARY_PATH="$QTDIR/lib:$QTDIR/plugins/designer:$QTDIR/plugins/imageformats"
        export PATH="$QTDIR/bin:$PATH"

        make install INSTALL_ROOT=%d

        #### COMPATIBILITY WITH OLD QT3 PACKAGES ####

        # set up symlinks for compatibility with some old packages

        # %p/bin
        install -d -m 0755 %i/bin
        for file in `cd %i/lib/qt3/bin; ls`; do
                ln -sf %p/lib/qt3/bin/$file %i/bin/$file
        done

#fink
#        # %p/include/qt
#        install -d -m 0755 %i/include
#        ln -sf %p/include/qt %i/lib/qt3/include
#darwinports
        # %p/include/qt3
        install -d -m 0755 %i/include
        ln -sf %p/include/qt3 %i/lib/qt3/include

        # %p/lib
        install -d -m 0755 %i/lib/qt3/lib
        mv %i/lib/*.* %i/lib/qt3/lib/

        for file in `cd %i/lib/qt3/lib; ls`; do
                [ "$file" != "pkgconfig" ] && ln -sf %p/lib/qt3/lib/$file %i/lib/$file
        done
#fink
#        install -d -m 0755 %i/lib/pkgconfig
#        ln -sf %p/lib/qt3/lib/pkgconfig/qt-mt.pc %i/lib/pkgconfig/
#darwinports
        perl -pi -e 's,\$\(QTDIR\),%p/lib/qt3,g' %i/lib/pkgconfig/qt-mt.pc
        install -d -m 0755 %i/lib/qt3/lib/pkgconfig
        ln -sf %p/lib/pkgconfig/qt-mt.pc %i/lib/qt3/lib/pkgconfig/

        # %p/lib/qt3/doc
        ln -sf %p/share/doc/%N %i/lib/qt3/doc

        #### CLEAN UP FILES ####

        # fix the -L$(QTDIR) junk in the .la file
        perl -pi -e 's,\$\(QTDIR\),%p/lib/qt3,g' %i/lib/qt3/lib/*.la

        # remove the .prl files, we don't want them
#fink
#        rm -rf %i/lib/qt3/lib/*.prl
#darwinports
        rm -rf %i/lib/qt3/lib/*.prl
	rm -rf %i/lib/*.prl

        #### MAN PAGES ####

        install -d -m 0755 %i/share/man/man1
        install -d -m 0755 %i/share/man/man3
        install -c -m 644  doc/man/man1/* %i/share/man/man1/
        install -c -m 644  doc/man/man3/* %i/share/man/man3/

        #### TUTORIALS AND EXAMPLES ####

        # clean up the makefiles
        perl -pi -e "s,^DEPENDPATH.*,,g;s,^REQUIRES.*,,g" `/usr/bin/find examples -name "*.pro"`

        install -d -m 0755 %i/share/doc/%N/tutorial
        install -d -m 0755 %i/share/doc/%N/examples
        /bin/cp -fRL tutorial/* %i/share/doc/%N/tutorial/
        /bin/cp -fRL examples/* %i/share/doc/%N/examples/

        # kde icon for qt designer
        install -d -m 0755 %i/share/applnk/Development
        cat >%i/share/applnk/Development/designer.desktop <<EOF
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
        cat >%i/share/applnk/Development/linguist.desktop <<EOF
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

        /usr/bin/find %i/share/doc/%n/ -name \*.moc -print0 | xargs -0 rm -rf {} >/dev/null 2>&1 || :
        /usr/bin/find %i/share/doc/%n/ -name \*.obj -print0 | xargs -0 rm -rf {} >/dev/null 2>&1 || :
        /usr/bin/find %i/share/doc/%n/examples %i/share/doc/%n/tutorial -name Makefile -print0 | xargs -0 rm -rf >/dev/null 2>&1 || :
        /usr/bin/find %i/share/doc/%n/ -name \*.pro -print0 | xargs -0 perl -pi -e 's,^(CONFIG\s*.*)$,$1 thread,' >/dev/null 2>&1 || :
        /usr/bin/find %i/ -name \*.bak -print0 | xargs -0 rm -rf >/dev/null 2>&1 || :

        install -d -m 755 %i/share/doc/installed-packages
        touch %i/share/doc/installed-packages/%N
        touch %i/share/doc/installed-packages/%N-dev
