#!/bin/sh -ex

        #### MAIN INSTALL ####

        unset QMAKESPEC
        export QTDIR=`pwd`
        export DYLD_LIBRARY_PATH="$QTDIR/lib:$QTDIR/plugins/designer:$QTDIR/plugins/imageformats"
        export PATH="$QTDIR/bin:$PATH"

        make -j1 install INSTALL_ROOT=%d

        #### COMPATIBILITY WITH OLD QT3 PACKAGES ####

        # set up symlinks for compatibility with some old packages

        # %p/bin
        install -d -m 0755 %i/bin
        for file in `cd %i/lib/%N/bin; ls`; do
                ln -sf %p/lib/%N/bin/$file %i/bin/$file
        done

#fink
#        # %p/include/qt
#        install -d -m 0755 %i/lib/%N/include
#        /bin/cp -fRL %i/include/qt/* %i/lib/%N/include/
#macports
        # %p/include/qt3
        install -d -m 0755 %i/lib/%N/include
        /bin/cp -fRL %i/include/qt3/* %i/lib/%N/include/

        # %p/lib
        install -d -m 0755 %i/lib/%N/lib
        mv %i/lib/*.* %i/lib/%N/lib/

        for file in `cd %i/lib/%N/lib; ls`; do
                [ "$file" != "pkgconfig" ] && ln -sf %N/lib/$file %i/lib/$file
        done

        # clean up some bad data in the .la and .pc files
        perl -pi -e "s,^libdir=.*,libdir='%p/lib/%N/lib',; s,-L..QTDIR./lib ,,; s,^includedir=.*,includedir='%p/lib/%N/include'," %i/lib/%N/lib/*.la %i/lib/pkgconfig/*.pc

        # %p/lib/%N/doc
        ln -sf ../../share/doc/%N %i/lib/%N/doc

        # mkspecs bad symlink
        rm -rf %i/lib/%N/mkspecs/default
        ln -sf darwin-g++ %i/lib/%N/mkspecs/default

        #### CLEAN UP FILES ####

        # fix the -L$(QTDIR) junk in the .la file
        perl -pi -e 's,\$\(QTDIR\),%p/lib/qt3,g' %i/lib/%N/lib/*.la

        # remove the .prl files, we don't want them
        rm -rf %i/lib{,/%N/lib}/*.prl

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
