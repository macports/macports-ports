--- file-chooser/sucky-desktop-item.c.org	Wed Sep 14 00:52:11 2005
+++ file-chooser/sucky-desktop-item.c	Wed Sep 14 00:54:15 2005
@@ -67,7 +67,12 @@
 
 #define sure_string(s) ((s)!=NULL?(s):"")
 
-extern char **environ;
+#ifdef __APPLE__
+# include <crt_externs.h>
++# define environ (*_NSGetEnviron())
+#elif
+ extern char **environ;
+#endif
 
 struct _SuckyDesktopItem {
 	int refcount;
