--- libgnome/gnome-util.c.org	Tue Nov 25 15:36:00 2003
+++ libgnome/gnome-util.c	Tue Nov 25 15:40:21 2003
@@ -189,28 +189,7 @@
 void
 gnome_unsetenv (const char *name)
 {
-#if defined (HAVE_SETENV)
 	unsetenv (name);
-#else
-	extern char **environ;
-	int i, len;
-
-	len = strlen (name);
-	
-	/* Mess directly with the environ array.
-	 * This seems to be the only portable way to do this.
-	 */
-	for (i = 0; environ[i] != NULL; i++) {
-		if (strncmp (environ[i], name, len) == 0
-		    && environ[i][len + 1] == '=') {
-			break;
-		}
-	}
-	while (environ[i] != NULL) {
-		environ[i] = environ[i + 1];
-		i++;
-	}
-#endif
 }
 
 /**
@@ -225,12 +204,7 @@
 void
 gnome_clearenv (void)
 {
-#ifdef HAVE_CLEARENV
-	clearenv ();
-#else
-	extern char **environ;
-	environ[0] = NULL;
-#endif
+	unsetenv (NULL);
 }
 
 
