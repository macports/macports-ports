--- vicious-extensions/ve-misc.c.org	Sat May  1 11:00:37 2004
+++ vicious-extensions/ve-misc.c	Sat May  1 11:04:06 2004
@@ -434,12 +434,7 @@
 void
 ve_clearenv (void)
 {
-#ifdef HAVE_CLEARENV
-	clearenv ();
-#else
-	extern char **environ;
-	environ[0] = NULL;
-#endif
+	unsetenv (NULL);
 }
 
 char *
