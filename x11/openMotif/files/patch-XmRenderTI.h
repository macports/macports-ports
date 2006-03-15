--- lib/Xm/XmRenderTI.h.orig	2006-03-15 02:07:00.000000000 -0500
+++ lib/Xm/XmRenderTI.h	2006-03-15 02:07:47.000000000 -0500
@@ -43,6 +43,8 @@
 
 #include <Xm/XmP.h>
 #ifdef	USE_XFT
+#include <ft2build.h>
+#include FT_FREETYPE_H
 #include <X11/Xft/Xft.h>
 #endif
 
