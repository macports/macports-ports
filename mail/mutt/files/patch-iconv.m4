--- m4/iconv.m4	Sat Apr 20 14:40:52 2002
+++ m4/iconv.m4	Fri Sep  6 02:16:30 2002
@@ -7,19 +7,14 @@
   dnl Some systems have iconv in libc, some have it in libiconv (OSF/1 and
   dnl those with the standalone portable GNU libiconv installed).
 
-  AC_ARG_WITH([iconv],
-[  --with-iconv[=DIR]  search for libiconv in DIR/include and DIR/lib], [
-    if test "$withval" != no ; then
+  AC_ARG_WITH([libiconv-prefix],
+[  --with-libiconv-prefix=DIR  search for libiconv in DIR/include and DIR/lib], [
     for dir in `echo "$withval" | tr : ' '`; do
       if test -d $dir/include; then CPPFLAGS="$CPPFLAGS -I$dir/include"; fi
       if test -d $dir/lib; then LDFLAGS="$LDFLAGS -L$dir/lib"; fi
     done
-    else
-      use_iconv=no
-    fi
-   ],use_iconv=yes)
+   ])
 
-  if test "$use_iconv" = yes ; then
   AC_CACHE_CHECK(for iconv, am_cv_func_iconv, [
     am_cv_func_iconv="no, consider installing GNU libiconv"
     am_cv_lib_iconv=no
@@ -71,6 +66,4 @@
     LIBICONV="-liconv"
   fi
   AC_SUBST(LIBICONV)
-
-  fi # use_iconv
 ])
