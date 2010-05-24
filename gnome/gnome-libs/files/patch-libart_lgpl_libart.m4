--- libart_lgpl/libart.m4.orig	2000-04-05 03:14:15.000000000 -0500
+++ libart_lgpl/libart.m4	2010-05-24 15:36:35.000000000 -0500
@@ -8,7 +8,7 @@
 dnl AM_PATH_LIBART([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
 dnl Test for LIBART, and define LIBART_CFLAGS and LIBART_LIBS
 dnl
-AC_DEFUN(AM_PATH_LIBART,
+AC_DEFUN([AM_PATH_LIBART],
 [dnl 
 dnl Get the cflags and libraries from the libart-config script
 dnl
