--- include/freetype/config/ftconfig.h.orig	Sat Jun 21 03:20:07 2003
+++ include/freetype/config/ftconfig.h	Sat Jun 21 03:20:51 2003
@@ -108,8 +108,10 @@
   /*   This is the only necessary change, so it is defined here instead    */
   /*   providing a new configuration file.                                 */
   /*                                                                       */
+#if 0	/* Undefine for now - breaks too many x11 ports in darwinports. */
 #if defined( __APPLE__ ) || ( defined( __MWERKS__ ) && defined( macintosh ) )
 #define FT_MACINTOSH 1
+#endif
 #endif
 
 
