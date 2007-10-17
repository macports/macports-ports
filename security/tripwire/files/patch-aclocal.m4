--- aclocal.m4.original	Sun Sep  2 10:52:05 2007
+++ aclocal.m4		Sun Sep  2 10:52:33 2007
@@ -33,14 +33,14 @@
 # ----------------------------
 # Automake X.Y traces this macro to ensure aclocal.m4 has been
 # generated from the m4 files accompanying Automake X.Y.
-AC_DEFUN([AM_AUTOMAKE_VERSION], [am__api_version="1.8"])
+AC_DEFUN([AM_AUTOMAKE_VERSION], [am__api_version="1.10"])
 
 # AM_SET_CURRENT_AUTOMAKE_VERSION
 # -------------------------------
 # Call AM_AUTOMAKE_VERSION so it can be traced.
 # This function is AC_REQUIREd by AC_INIT_AUTOMAKE.
 AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
-	 [AM_AUTOMAKE_VERSION([1.8.5])])
+	 [AM_AUTOMAKE_VERSION([1.10])])
 
 # AM_AUX_DIR_EXPAND
 
@@ -469,11 +469,15 @@
 AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
 AC_REQUIRE([AC_PROG_INSTALL])dnl
 # test to see if srcdir already configured
-if test "`cd $srcdir && pwd`" != "`pwd`" &&
-   test -f $srcdir/config.status; then
-  AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
+if test "`cd $srcdir && pwd`" != "`pwd`"; then
+# Use -I$(srcdir) only when $(srcdir) != ., so that make's output
+# is not polluted with repeated "-I."
+AC_SUBST([am__isrc], [' -I$(srcdir)'])_AM_SUBST_NOTMAKE([am__isrc])dnl
+# test to see if srcdir already configured
+if test -f $srcdir/config.status; then
+AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
+fi
 fi
-
 # test whether we have cygpath
 if test -z "$CYGPATH_W"; then
   if (cygpath --version) >/dev/null 2>/dev/null; then
