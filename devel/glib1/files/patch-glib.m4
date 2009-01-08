--- glib.m4.orig	2008-09-12 12:17:30.000000000 -0700
+++ glib.m4	2008-09-12 12:17:41.000000000 -0700
@@ -5,7 +5,7 @@
 dnl Test for GLIB, and define GLIB_CFLAGS and GLIB_LIBS, if "gmodule" or 
 dnl gthread is specified in MODULES, pass to glib-config
 dnl
-AC_DEFUN(AM_PATH_GLIB,
+AC_DEFUN([AM_PATH_GLIB],
 [dnl 
 dnl Get the cflags and libraries from the glib-config script
 dnl
