--- libs/Picture.h.orig	Sat Feb  7 12:53:41 2004
+++ libs/Picture.h	Sat Feb  7 12:53:47 2004
@@ -32,11 +32,11 @@
     int nalloc_pixels;
 } Picture;
 
-extern Bool Pdefault;
-extern Visual *Pvisual;
-extern Colormap Pcmap;
-extern unsigned int Pdepth;
-extern Display *Pdpy;     /* Save area for display pointer */
+Bool Pdefault;
+Visual *Pvisual;
+Colormap Pcmap;
+unsigned int Pdepth;
+Display *Pdpy;     /* Save area for display pointer */
 
 
 /* This routine called during fvwm and some modules initialization */
