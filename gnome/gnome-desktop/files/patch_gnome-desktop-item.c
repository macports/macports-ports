--- libgnome-desktop/gnome-desktop-item.c.org	Tue Nov 25 20:59:15 2003
+++ libgnome-desktop/gnome-desktop-item.c	Tue Nov 25 21:00:05 2003
@@ -27,6 +27,11 @@
   @NOTATION@
  */
 
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#endif
+
 #include "config.h"
 
 #include <limits.h>
@@ -1482,8 +1487,6 @@
 {
 	gdk_error_trap_pop ();
 }
-
-extern char **environ;
 
 static char **
 make_spawn_environment_for_sn_context (SnLauncherContext *sn_context,
