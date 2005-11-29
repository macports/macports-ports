--- gdk/x11/gdkspawn-x11.c.orig	2005-09-21 10:10:43.000000000 +0100
+++ gdk/x11/gdkspawn-x11.c	2005-09-21 10:22:42.000000000 +0100
@@ -28,7 +28,8 @@
 #include <gdk/gdk.h>
 #include "gdkalias.h"
 
-extern char **environ;
+#include <crt_externs.h> /* For _NSGetEnviron */
+#define environ (*_NSGetEnviron())
 
 /**
  * gdk_make_spawn_environment_for_screen:
