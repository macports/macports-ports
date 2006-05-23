#!/bin/sh -e

  export HOME=/tmp
  export PREFIX="%p" UNSERMAKE=1

#fink
#  . ./environment-helper.sh
#  export lt_cv_sys_max_cmd_len=65536 ac_cv_prog_RUBY=%p/bin/ruby1.8
#  export CC=gcc CXX=g++ CONFIGURE_PARAMS=`echo $CONFIGURE_PARAMS | sed -e 's,--disable-dependency-tracking,,'`
#darwinports
  . ./environment-helper.sh
  export lt_cv_sys_max_cmd_len=65536 ac_cv_prog_RUBY=%p/bin/ruby
  export CC=gcc CXX=g++ CONFIGURE_PARAMS=`echo $CONFIGURE_PARAMS | sed -e 's,--disable-dependency-tracking,,'`

  ./build-helper.sh cvs       %N %v %r make -f admin/Makefile.common cvs
  ./build-helper.sh configure %N %v %r ./configure %c $CONFIGURE_PARAMS

  # why does this work??
  find . -name \*.h | xargs touch

  MAKEFLAGS="-j1" ./build-helper.sh make-drivers %N %v %r unsermake -p kexi/kexidb/drivers/sqlite/kexidb_sqlite3driver.la kexi/kexidb/drivers/sqlite2/kexidb_sqlite2driver.la
  ./build-helper.sh make      %N %v %r unsermake -p
