--- cut-n-paste-code/libegg/egg-screen-exec.c.org	Fri Nov 28 16:35:28 2003
+++ cut-n-paste-code/libegg/egg-screen-exec.c	Fri Nov 28 16:35:44 2003
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
