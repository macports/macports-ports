--- configure.h.orig	Mon Oct 14 20:14:39 2002
+++ configure.h	Mon Oct 14 20:14:48 2002
@@ -1,7 +1,7 @@
-#define FVWMDIR     "/usr/lib/X11/fvwm"
+#define FVWMDIR     "/usr/X11R6/lib/X11/fvwm"
 /* #define FVWMDIR        "/local/homes/dsp/nation/modules"*/
-#define FVWM_ICONDIR   "/usr/include/X11/bitmaps:/usr/include/X11/pixmaps"
-#define FVWMRC         "/usr/lib/X11/fvwm/system.fvwmrc"
+#define FVWM_ICONDIR   "/usr/X11R6/include/X11/bitmaps:/usr/X11R6/include/X11/pixmaps"
+#define FVWMRC         "/usr/X11R6/lib/X11/fvwm/system.fvwmrc"
 
 /* Imake command needed to put modules in desired target location */
 /* Use the second version if it causes grief */
@@ -14,7 +14,7 @@
  * If you want to install it in a different directory, uncomment and
  * edit the first line */
 /* #define FVWM_BIN_DIR BINDIR=/local/homes/dsp/nation/bin/4.1.3*/
-#define FVWM_BIN_DIR BINDIR=/usr/bin/X11
+#define FVWM_BIN_DIR BINDIR=/usr/X11R6/bin
 /*#define FVWM_BIN_DIR*/
 
 /* Compiler over-ride for Imakefiles */
@@ -57,7 +57,7 @@
  ***************************************************************************/
 #define XPM                      
 /*  linker flags needed to locate and link in the Xpm library, if you use it */
-#define XPMLIBRARY -L/usr/lib/X11 -lXpm
+#define XPMLIBRARY -L/usr/X11R6/lib -lXpm
 
 /***************************************************************************
  *#define M4
