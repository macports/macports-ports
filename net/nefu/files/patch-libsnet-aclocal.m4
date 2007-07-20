--- libsnet/aclocal.m4	2006-03-10 14:52:53.000000000 +0000
+++ libsnet/aclocal.m4.new	2007-06-16 02:26:11.000000000 +0000
@@ -99,6 +99,8 @@
 			CPPFLAGS="$CPPFLAGS -I$zlibdir/include";
 	    fi
 	    AC_DEFINE(HAVE_ZLIB)
+	    LIBS="$LIBS -lz";
+	    LDFLAGS="$LDFLAGS -L$zlibdir/lib";
 	    AC_MSG_RESULT(yes)
 	else
 	    AC_MSG_RESULT(no)
