--- libgnome-desktop/gnome-desktop-item.c.org	Fri Sep 17 22:05:13 2004
+++ libgnome-desktop/gnome-desktop-item.c	Fri Sep 17 22:05:16 2004
@@ -62,7 +62,11 @@
 
 #define sure_string(s) ((s)!=NULL?(s):"")
 
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
+# define environ (*_NSGetEnviron())
+#elif extern char **environ;
+#endif
 
 struct _GnomeDesktopItem {
 	int refcount;
