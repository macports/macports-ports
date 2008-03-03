--- libraries/hpc/aclocal.m4.sav	1969-12-31 19:00:00.000000000 -0500
+++ libraries/hpc/aclocal.m4	2007-12-17 16:44:44.000000000 -0500
@@ -0,0 +1,17 @@
+# FP_ARG_GMP
+# -------------
+AC_DEFUN([FP_ARG_GMP],
+[
+AC_ARG_WITH([gmp-includes],
+  [AC_HELP_STRING([--with-gmp-includes],
+    [directory containing gmp.h])],
+    [gmp_includes=$withval],
+    [gmp_includes=NONE])
+
+AC_ARG_WITH([gmp-libraries],
+  [AC_HELP_STRING([--with-gmp-libraries],
+    [directory containing gmp library])],
+    [gmp_libraries=$withval],
+    [gmp_libraries=NONE])
+])# FP_ARG_GMP
+
