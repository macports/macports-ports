--- libnautilus-private/nautilus-program-choosing.c.orig	Wed Feb 11 16:37:03 2004
+++ libnautilus-private/nautilus-program-choosing.c	Wed Apr  7 13:33:57 2004
@@ -71,7 +71,12 @@
 
 static GHashTable *choose_application_hash_table, *choose_component_hash_table;
 
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
 
 /* Cut and paste from gdkspawn-x11.c */
 static gchar **
@@ -634,7 +639,12 @@
 	gdk_error_trap_pop ();
 }
 
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
 extern char **environ;
+#endif
 
 static char **
 make_spawn_environment_for_sn_context (SnLauncherContext *sn_context,
