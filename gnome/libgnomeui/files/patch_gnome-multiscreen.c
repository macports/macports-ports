--- libgnomeui/gnome-multiscreen.c.org	Mon Apr  5 20:14:10 2004
+++ libgnomeui/gnome-multiscreen.c	Mon Apr  5 20:14:30 2004
@@ -26,7 +26,12 @@
 
 #include <string.h>
 
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
 
 /**
  * make_environment_for_screen:
