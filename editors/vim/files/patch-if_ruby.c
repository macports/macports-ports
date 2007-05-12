--- src/if_ruby.c.orig	2007-05-12 05:06:53.000000000 -0400
+++ src/if_ruby.c	2007-05-12 05:07:37.000000000 -0400
@@ -54,7 +54,7 @@
 #undef _
 
 /* T_DATA defined both by Ruby and Mac header files, hack around it... */
-#ifdef MACOS
+#if defined(MACOS_X_UNIX) || defined(macintosh)
 # define __OPENTRANSPORT__
 # define __OPENTRANSPORTPROTOCOL__
 # define __OPENTRANSPORTPROVIDERS__
