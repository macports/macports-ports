--- gdk/x11/gdkdrawable-x11.c.orig	Fri Nov  8 07:27:22 2002
+++ gdk/x11/gdkdrawable-x11.c	Mon Apr  7 02:00:38 2003
@@ -1006,6 +1006,7 @@
     }
   else
     {
+      /* RGBA */
       pf.direct.alpha = 0;
     }
   
@@ -1022,10 +1023,18 @@
    * RENDER's preferred order
    */
   pf.direct.alphaMask = 0;
-  /* ARGB */
-  pf.direct.red = 16;
-  pf.direct.green = 8;
-  pf.direct.blue = 0;
+  if (ImageByteOrder (xdisplay) == LSBFirst)
+    {
+      /* ARGB */
+      pf.direct.red = 16;
+      pf.direct.green = 8;
+      pf.direct.blue = 0;
+    } else {
+      /* BGRA */
+      pf.direct.red = 8;
+      pf.direct.green = 16;
+      pf.direct.blue = 24;
+    }
   
   *format = XRenderFindFormat (xdisplay,
 			       (PictFormatType | PictFormatDepth |
@@ -1037,7 +1046,14 @@
 			       0);
 
   pf.direct.alphaMask = 0xff;
-  pf.direct.alpha = 24;
+  if (ImageByteOrder (xdisplay) == LSBFirst)
+    {
+      /* ARGB */
+      pf.direct.alpha = 24;
+    } else {
+      /* BGRA */
+      pf.direct.alpha = 0;
+    }
   
   *mask = XRenderFindFormat (xdisplay,
 			     (PictFormatType | PictFormatDepth |
@@ -1054,11 +1070,19 @@
 
   pf.type = PictTypeDirect;
   pf.depth = 32;
-  pf.direct.red = 16;
-  pf.direct.green = 8;
-  pf.direct.blue = 0;
+  if (ImageByteOrder (xdisplay) == LSBFirst)
+    {
+      pf.direct.red = 16;
+      pf.direct.green = 8;
+      pf.direct.blue = 0;
+      pf.direct.alpha = 24;
+    } else {
+      pf.direct.red = 8;
+      pf.direct.green = 16;
+      pf.direct.blue = 24;
+      pf.direct.alpha = 0;
+    }
   pf.direct.alphaMask = 0xff;
-  pf.direct.alpha = 24;
 
   *format = XRenderFindFormat (xdisplay,
 			       (PictFormatType | PictFormatDepth |
