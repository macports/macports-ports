--- libgnome-desktop/egg-spawn.c.org	Tue Nov 25 20:59:45 2003
+++ libgnome-desktop/egg-spawn.c	Tue Nov 25 21:01:11 2003
@@ -20,6 +20,11 @@
  * Authors: Mark McLoughlin <mark@skynet.ie>
  */
 
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#endif
+
 #include <config.h>
 #include <string.h>
 
@@ -27,8 +32,6 @@
 
 #include <glib.h>
 #include <gdk/gdk.h>
-
-extern char **environ;
 
 /**
  * egg_make_spawn_environment_for_screen:
