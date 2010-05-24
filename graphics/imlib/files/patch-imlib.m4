--- imlib.m4.orig	2004-08-27 11:03:11.000000000 -0500
+++ imlib.m4	2010-05-24 16:53:21.000000000 -0500
@@ -6,7 +6,7 @@
 dnl AM_PATH_IMLIB([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
 dnl Test for IMLIB, and define IMLIB_CFLAGS and IMLIB_LIBS
 dnl
-AC_DEFUN(AM_PATH_IMLIB,
+AC_DEFUN([AM_PATH_IMLIB],
 [dnl 
 dnl Get the cflags and libraries from the imlib-config script
 dnl
@@ -164,7 +164,7 @@
 ])
 
 # Check for gdk-imlib
-AC_DEFUN(AM_PATH_GDK_IMLIB,
+AC_DEFUN([AM_PATH_GDK_IMLIB],
 [dnl 
 dnl Get the cflags and libraries from the imlib-config script
 dnl
