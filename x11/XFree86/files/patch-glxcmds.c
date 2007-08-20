--- lib/GL/glx/glxcmds.c.orig	2007-08-20 09:48:43.000000000 -0400
+++ lib/GL/glx/glxcmds.c	2007-08-20 09:51:06.000000000 -0400
@@ -47,8 +47,10 @@
 #include "glapi.h"
 #ifdef GLX_DIRECT_RENDERING
 #include "indirect_init.h"
+#ifdef XF86VIDMODE
 #include <X11/extensions/xf86vmode.h>
 #endif
+#endif
 #include "glxextensions.h"
 #include "glcontextmodes.h"
 #include <sys/time.h>
