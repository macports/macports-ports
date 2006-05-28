--- include/freetype/config/ftconfig.h.old	Mon Mar  1 05:35:28 2004
+++ include/freetype/config/ftconfig.h	Mon Mar  1 05:36:03 2004
@@ -121,9 +121,11 @@
   /*   This is the only necessary change, so it is defined here instead    */
   /*   providing a new configuration file.                                 */
   /*                                                                       */
+#if 0  /* Undefine for now - breaks too many x11 ports in darwinports. */
 #if ( defined( __APPLE__ ) && !defined( DARWIN_NO_CARBON ) ) || \
     ( defined( __MWERKS__ ) && defined( macintosh )        )
 #define FT_MACINTOSH 1
+#endif
 #endif
 
 
