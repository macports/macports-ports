#!/bin/sh -ex

#fink
#        CURRENTVERSION=`dpkg -p qt3 | grep '^Version:' | cut -d' ' -f2-`
#        DOREMOVE=0
#        for BADUPGRADE in 3.2.1-1 3.2.1-11 3.2.1-12; do
#                if [ "$CURRENTVERSION" = "$BADUPGRADE" ]; then
#                        DOREMOVE=1
#                fi
#        done
#macports
#

#fink
#        for file in `ls -1 /lib/ 2>/dev/null | grep -E '(qt-mt|qt3)' | grep -v '.bad$'`; do
#                echo "WARNING: found suspicious file or directory \"$file\" -- moving to \"${file}.bad\""
#                /bin/mv "/lib/${file}" "/lib/${file}.bad"
#        done
#macports
        for file in `ls -1 /lib/ 2>/dev/null | grep -E '(qt-mt|qt3)' | grep -v '.bad$'`; do
                echo "WARNING: found suspicious file or directory \"$file\" -- please remove it first.\""
		exit 1
        done

#fink
#        if [ "$DOREMOVE" = "1" ]; then
#                echo "You have a version of qt3 installed that contains a bug that makes it impossible"
#                echo "to build this package.    I am going to remove qt3 not to allow the upgrade to"
#                echo "happen.   It should get re-installed as needed when the upgrade completes."
#                echo ""
#                echo -e "removing qt3... \c"
#                if dpkg -r --force-depends qt3 >/tmp/dpkg.output 2>&1; then
#                        echo "done"
#                else
#                        echo "failed!"
#                        echo ""
#                        echo "I was unable to remove the old qt3, this will probably cause problems building"
#                        echo "this package.     Please remove qt3 and then retry this build."
#                        echo ""
#                        echo "---( dpkg output )---"
#                        cat /tmp/dpkg.output
#                fi
#        fi
#macports
#

#fink
#        unset QMAKESPEC
#        export QTDIR=`pwd`
#        export DYLD_LIBRARY_PATH="$QTDIR/lib:$QTDIR/plugins/designer:$QTDIR/plugins/imageformats"
#        export PATH="$QTDIR/bin:%p/lib/freetype219/bin:$PATH"
#        export INSTALL_ROOT=""
#macports
        unset QMAKESPEC
        export QTDIR=`pwd`
        export DYLD_LIBRARY_PATH="$QTDIR/lib:$QTDIR/plugins/designer:$QTDIR/plugins/imageformats"
        export PATH="$QTDIR/bin:$PATH"
        export INSTALL_ROOT=""
	# ~/.qt/ is created during the build process.
	export HOME="$QTDIR"


        if [ -f /usr/lib/libresolv.dylib ]; then
                LIBRESOLV="-lresolv"
                perl -pi -e 's,#define QT_AOUT_UNDERSCORE,,' mkspecs/darwin-g++/qplatformdefs.h
        else
                LIBRESOLV=""
        fi

#fink
#        # we have to force header/lib ordering or things get really wiggy
#        # looks ugly, but it's better than patching the source
#        echo "yes" | ./configure $DEFINES \
#                '-I$(QTDIR)/include' '-L$(QTDIR)/lib' \
#                '-I%p/lib/freetype219/include' '-I%p/lib/freetype219/include/freetype2' '-L%p/lib/freetype219/lib' \
#                '-I%p/include' '-L%p/lib' \
#                '-I/usr/X11R6/include' '-L/usr/X11R6/lib' \
#                $LIBRESOLV -buildkey qt3-jaguar \
#                -platform darwin-g++ -xplatform darwin-g++ \
#                -prefix '%p/lib/qt3' -docdir '%p/share/doc/%n' \
#                -headerdir '%p/include/qt' -libdir '%p/lib' \
#                -release -shared -no-exceptions -thread -cups -stl \
#                -qt-gif -plugin-imgfmt-png -plugin-imgfmt-jpeg -plugin-imgfmt-mng \
#                -system-libpng -system-libjpeg -system-zlib -largefile \
#                -sm -xinerama -xrender -xft -xkb \
#                -plugin-sql-sqlite -no-sql-ibase -no-sql-mysql -no-sql-odbc -no-sql-psql 
#macports
        echo "yes" | ./configure \
	    '-I$(QTDIR)/include' '-L$(QTDIR)/lib' \
	    '-I%p/include' '-L%p/lib' \
	    '-I/usr/X11R6/include' '-L/usr/X11R6/lib' \
	    $LIBRESOLV %c

        __MAKE__
