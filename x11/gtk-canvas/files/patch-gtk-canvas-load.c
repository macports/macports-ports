--- gtk-canvas/gtk-canvas-load.c.old	2006-01-23 23:01:44.000000000 -0800
+++ gtk-canvas/gtk-canvas-load.c	2006-01-23 23:01:56.000000000 -0800
@@ -12,7 +12,7 @@
  */
 #include <config.h>
 #include <gdk_imlib.h>
-#include <malloc.h>
+#include <malloc/malloc.h>
 #include "gtk-canvas.h"
 #include "gtk-canvas-load.h"
 
