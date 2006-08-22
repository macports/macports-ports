--- include/config.h	2006-08-05 16:00:45.000000000 +0900
+++ include/config.h	2006-08-05 16:21:55.000000000 +0900
@@ -44,7 +44,7 @@
  * Some combinations make no sense.  See the installation document.
  */
 #define TTY_GRAPHICS	/* good old tty based graphics */
-/* #define X11_GRAPHICS */	/* X11 interface */
+#define X11_GRAPHICS	/* X11 interface */
 /* #define QT_GRAPHICS */	/* Qt interface */
 /* #define GNOME_GRAPHICS */	/* Gnome interface */
 /* #define MSWIN_GRAPHICS */	/* Windows NT, CE, Graphics */
@@ -133,7 +133,7 @@
  * would allow:
  *  xpmtoppm <x11tiles.xpm | pnmscale 1.25 | ppmquant 90 >x11tiles_big.xpm
  */
-/*# define USE_XPM*/		/* Disable if you do not have the XPM library */
+# define USE_XPM		/* Disable if you do not have the XPM library */
 # ifdef USE_XPM
 #  define GRAPHIC_TOMBSTONE	/* Use graphical tombstone (rip.xpm) */
 #  define X11LARGETILE		/* Large tile for X11 */
@@ -368,7 +368,7 @@
  */
 
 /*#define GOLDOBJ */	/* Gold is kept on obj chains - Helge Hafting */
-/*#define AUTOPICKUP_EXCEPTIONS */ /* exceptions to autopickup */
+#define AUTOPICKUP_EXCEPTIONS  /* exceptions to autopickup */
 
 /* End of Section 5 */
 
