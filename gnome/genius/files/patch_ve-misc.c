--- vicious-extensions/ve-misc.c.org	Wed Jun 16 07:04:49 2004
+++ vicious-extensions/ve-misc.c	Wed Jun 16 07:06:03 2004
@@ -28,6 +28,13 @@
 
 #include "ve-misc.h"
 
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
+
 char **
 ve_split (const char *s)
 {
@@ -364,9 +371,6 @@
 int
 ve_setenv (const char *name, const char *value, gboolean overwrite)
 {
-#if defined (HAVE_SETENV)
-	return setenv (name, value != NULL ? value : "", overwrite);
-#else
 	char *string;
 	
 	if (! overwrite && g_getenv (name) != NULL) {
@@ -379,7 +383,6 @@
 	 */
 	string = g_strconcat (name, "=", value, NULL);
 	return putenv (string);
-#endif
 }
 #endif
 
@@ -397,10 +400,6 @@
 void
 ve_unsetenv (const char *name)
 {
-#if defined (HAVE_SETENV)
-	unsetenv (name);
-#else
-	extern char **environ;
 	int i, len;
 
 	if (environ == NULL)
@@ -421,7 +420,6 @@
 		environ[i] = environ[i + 1];
 		i++;
 	}
-#endif
 }
 #endif
 
@@ -437,13 +435,8 @@
 void
 ve_clearenv (void)
 {
-#ifdef HAVE_CLEARENV
-	clearenv ();
-#else
-	extern char **environ;
 	if (environ != NULL)
 		environ[0] = NULL;
-#endif
 }
 
 char *
