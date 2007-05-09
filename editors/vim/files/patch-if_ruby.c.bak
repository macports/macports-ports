--- src/if_ruby.c.orig	2006-12-14 16:14:39.000000000 -0500
+++ src/if_ruby.c	2006-12-14 16:14:55.000000000 -0500
@@ -54,7 +54,7 @@
 #undef _
 
 /* T_DATA defined both by Ruby and Mac header files, hack around it... */
-#ifdef FEAT_GUI_MAC
+#ifdef MACOS_X_UNIX		/* was FEAT_GUI_MAC */
 # define __OPENTRANSPORT__
 # define __OPENTRANSPORTPROTOCOL__
 # define __OPENTRANSPORTPROVIDERS__
