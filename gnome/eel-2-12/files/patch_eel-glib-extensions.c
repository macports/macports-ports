--- eel/eel-glib-extensions.c.org	Wed Apr  7 12:30:35 2004
+++ eel/eel-glib-extensions.c	Wed Apr  7 12:31:06 2004
@@ -54,8 +54,11 @@
 static GList *hash_tables_to_free_at_exit;
 
 /* We will need this for eel_unsetenv if there is no unsetenv. */
-#if !defined (HAVE_UNSETENV)
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
 #endif
 
 /**
