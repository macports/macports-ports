--- gnome-keyring-daemon.c.org	Wed Apr  7 12:19:00 2004
+++ gnome-keyring-daemon.c	Wed Apr  7 12:19:26 2004
@@ -68,8 +68,12 @@
 	gpointer                           callback_data;
 } GnomeKeyringAsk;
 
-
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
 
 gboolean have_display = FALSE;
 
