--- libgnome/gnome-util.c.org	Fri Sep 17 18:45:43 2004
+++ libgnome/gnome-util.c	Fri Sep 17 18:47:11 2004
@@ -189,10 +189,11 @@
 void
 gnome_unsetenv (const char *name)
 {
-#if defined (HAVE_UNSETENV)
-	unsetenv (name);
-#else
-	extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif extern char **environ;
+#endif
 	int i, len;
 
 	len = strlen (name);
@@ -210,7 +211,6 @@
 		environ[i] = environ[i + 1];
 		i++;
 	}
-#endif
 }
 
 /**
@@ -225,12 +225,14 @@
 void
 gnome_clearenv (void)
 {
-#ifdef HAVE_CLEARENV
-	clearenv ();
-#else
-	extern char **environ;
-	environ[0] = NULL;
+
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif extern char **environ;
 #endif
+
+	environ[0] = NULL;
 }
 
 
