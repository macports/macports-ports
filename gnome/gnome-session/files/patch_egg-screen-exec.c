--- gnome-session/egg-screen-exec.c.org	Wed Apr  7 12:22:43 2004
+++ gnome-session/egg-screen-exec.c	Wed Apr  7 12:23:08 2004
@@ -31,7 +31,12 @@
 #include <gdk/gdkx.h>
 #endif
 
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
 
 /**
  * egg_screen_exec_display_string:
