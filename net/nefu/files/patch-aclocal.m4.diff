--- aclocal.m4	2007-06-16 03:56:22.000000000 +0000
+++ aclocal.m4.new	2007-06-16 04:56:59.000000000 +0000
@@ -11,7 +11,7 @@
     # ldapdirs will be "yes", "no", or a user defined path
     if test x_$ldapdirs != x_no; then
 	if test x_$ldapdirs = x_yes; then
-	    ldapdirs="/usr /usr/local /usr/local/ldap /usr/local/openldap"
+	    ldapdirs="$prefix /usr /usr/local /usr/local/ldap /usr/local/openldap"
 	fi
 
 	for dir in $ldapdirs; do
@@ -187,10 +187,45 @@
     else
 	TLSDEFS=-DTLS;
 	AC_SUBST(TLSDEFS)
-	LIBS="$LIBS -lssl -lcrypt";
+	LIBS="$LIBS -lssl -lcrypto";
 	LDFLAGS="$LDFLAGS -L$ssldir/lib";
 	HAVE_SSL=yes
     fi
     AC_SUBST(HAVE_SSL)
     AC_MSG_RESULT(yes)
 ])
+
+AC_DEFUN([CHECK_ZLIB],
+[
+    AC_MSG_CHECKING(for zlib)
+    zlibdirs="/usr /usr/local"
+	withval=""
+    AC_ARG_WITH(zlib,
+            [AC_HELP_STRING([--with-zlib=DIR], [path to zlib])],
+            [])
+    if test x_$withval != x_no; then
+	if test x_$withval != x_yes -a \! -z "$withval"; then
+		zlibdirs="$answer"
+	fi
+	for dir in $zlibdirs; do
+	    zlibdir="$dir"
+	    if test -f "$dir/include/zlib.h"; then
+			found_zlib="yes";
+			break;
+		fi
+	done
+	if test x_$found_zlib == x_yes; then
+		if test "$dir" != "/usr"; then
+			CPPFLAGS="$CPPFLAGS -I$zlibdir/include";
+	    fi
+	    AC_DEFINE(HAVE_ZLIB)
+	    LIBS="$LIBS -lz";
+	    LDFLAGS="$LDFLAGS -L$zlibdir/lib";
+	    AC_MSG_RESULT(yes)
+	else
+	    AC_MSG_RESULT(no)
+	fi
+    else
+	AC_MSG_RESULT(no)
+    fi
+])
