--- src/terminal-screen.c.org	Wed Apr  7 12:25:31 2004
+++ src/terminal-screen.c	Wed Apr  7 12:25:54 2004
@@ -1013,7 +1013,12 @@
   return TRUE;
 }
 
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
 
 static char**
 get_child_environment (GtkWidget      *term,
