--- include/freetype/config/ftconfig.h.orig	Mon Jan 19 20:57:13 2004
+++ include/freetype/config/ftconfig.h	Mon Jan 19 20:57:36 2004
@@ -108,9 +108,11 @@
   /*   This is the only necessary change, so it is defined here instead    */
   /*   providing a new configuration file.                                 */
   /*                                                                       */
+#if 0  /* Undefine for now - breaks too many x11 ports in darwinports */
 #if ( defined( __APPLE__ ) && !defined( DARWIN_NO_CARBON ) ) || \
     ( defined( __MWERKS__ ) && defined( macintosh )        )
 #define FT_MACINTOSH 1
+#endif
 #endif
 
 
