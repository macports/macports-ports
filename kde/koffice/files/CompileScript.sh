#!/bin/sh -ev

        export PREFIX="%p" USE_UNSERMAKE=1

#fink
#       . ./environment-helper.sh
#       export ac_cv_prog_RUBY=%p/bin/ruby1.8
#       export CONFIGURE_PARAMS=`echo $CONFIGURE_PARAMS | sed -e 's,--disable-dependency-tracking,,'`
#macports
        . ./environment-helper.sh
        export ac_cv_prog_RUBY=%p/bin/ruby
        export CONFIGURE_PARAMS=`echo $CONFIGURE_PARAMS | sed -e 's,--disable-dependency-tracking,,'`

        ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
        ./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS

        # why does this work??
        find . -name \*.h | xargs touch

        MAKEFLAGS="-j1" ./build-helper.sh make-drivers %N %v %r unsermake $UNSERMAKEFLAGS kexi/kexidb/drivers/sqlite/kexidb_sqlite3driver.la kexi/kexidb/drivers/sqlite2/kexidb_sqlite2driver.la
	MAKEFLAGS="-j1" ./build-helper.sh make-ksqlite %N %v %r unsermake $UNSERMAKEFLAGS kexi/3rdparty/kexisql3/src/ksqlite
	./build-helper.sh make      %N %v %r unsermake $UNSERMAKEFLAGS
