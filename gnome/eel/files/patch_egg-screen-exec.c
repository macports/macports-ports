--- eel/egg-screen-exec.c.org	Wed Nov 26 18:20:55 2003
+++ eel/egg-screen-exec.c	Wed Nov 26 18:22:17 2003
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
