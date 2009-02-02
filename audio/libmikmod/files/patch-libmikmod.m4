--- libmikmod.m4.orig	2004-01-20 19:36:34.000000000 -0600
+++ libmikmod.m4	2009-01-09 02:19:33.000000000 -0600
@@ -8,7 +8,7 @@
 dnl Test for libmikmod, and define LIBMIKMOD_CFLAGS, LIBMIKMOD_LIBS and
 dnl LIBMIKMOD_LDADD
 dnl
-AC_DEFUN(AM_PATH_LIBMIKMOD,
+AC_DEFUN([AM_PATH_LIBMIKMOD],
 [dnl 
 dnl Get the cflags and libraries from the libmikmod-config script
 dnl
