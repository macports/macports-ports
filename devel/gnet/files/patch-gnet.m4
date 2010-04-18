--- gnet.m4.orig	2001-11-09 13:43:22.000000000 -0600
+++ gnet.m4	2010-04-18 10:28:08.000000000 -0500
@@ -6,7 +6,7 @@
 dnl AM_PATH_GNET([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND [, MODULES]]]])
 dnl Test for GNET, and define GNET_CFLAGS and GNET_LIBS
 dnl
-AC_DEFUN(AM_PATH_GNET,
+AC_DEFUN([AM_PATH_GNET],
 [dnl 
 dnl Get the cflags and libraries from the gnet-config script
 dnl
