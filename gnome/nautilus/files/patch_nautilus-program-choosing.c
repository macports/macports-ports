--- libnautilus-private/nautilus-program-choosing.c.org	Thu Nov 27 17:43:45 2003
+++ libnautilus-private/nautilus-program-choosing.c	Thu Nov 27 17:44:04 2003
@@ -565,7 +565,12 @@
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
