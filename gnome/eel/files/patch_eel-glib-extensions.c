--- eel/eel-glib-extensions.c.org	Wed Nov 26 18:21:37 2003
+++ eel/eel-glib-extensions.c	Wed Nov 26 18:23:51 2003
@@ -54,7 +54,12 @@
 
 /* We will need this for eel_unsetenv if there is no unsetenv. */
 #if !defined (HAVE_SETENV)
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
 extern char **environ;
+#endif
 #endif
 
 /**
