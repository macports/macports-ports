--- oaf.m4.orig	2006-11-12 15:27:24.000000000 +0200
+++ oaf.m4	2007-07-05 13:26:31.000000000 +0300
@@ -1,7 +1,7 @@
 dnl AM_PATH_OAF([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND [, MODULES]]]])
 dnl Test for OAF, and define OAF_CFLAGS and OAF_LIBS
 dnl
-AC_DEFUN(AM_PATH_OAF,
+AC_DEFUN([AM_PATH_OAF],
 [dnl 
 dnl Get the cflags and libraries from the oaf-config script
 dnl
