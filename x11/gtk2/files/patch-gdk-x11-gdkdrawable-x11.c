--- gdk/x11/gdkdrawable-x11.c	Thu Apr 18 07:55:01 2002
+++ gdk/x11/gdkdrawable-x11.c	Sun Jun 23 02:06:02 2002
@@ -853,6 +853,7 @@
     }
   else
     {
+      /* RGBA */
       pf.direct.alpha = 0;
     }
   
@@ -869,10 +870,18 @@
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
@@ -884,7 +893,14 @@
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
@@ -901,11 +917,19 @@
 
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
