--- applets/clock/egg-screen-exec.c.org	Wed Nov 26 16:09:48 2003
+++ applets/clock/egg-screen-exec.c	Wed Nov 26 16:10:16 2003
@@ -31,7 +31,12 @@
 #include <gdk/gdkx.h>
 #endif
 
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
 extern char **environ;
+#endif
 
 /**
  * egg_screen_exec_display_string:
