--- libraries/base/aclocal.m4.sav	2007-12-17 16:35:32.000000000 -0500
+++ libraries/base/aclocal.m4	2007-12-17 16:36:23.000000000 -0500
@@ -1,3 +1,21 @@
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
+
 # FP_COMPUTE_INT(EXPRESSION, VARIABLE, INCLUDES, IF-FAILS)
 # --------------------------------------------------------
 # Assign VARIABLE the value of the compile-time EXPRESSION using INCLUDES for
