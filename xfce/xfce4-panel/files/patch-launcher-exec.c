Index: plugins/launcher/launcher-exec.c
===================================================================
--- plugins/launcher/launcher-exec.c	(revision 29263)
+++ plugins/launcher/launcher-exec.c	(working copy)
@@ -63,8 +63,18 @@
 #include <libsn/sn.h>
 #endif
 
+#ifdef __APPLE__
+/* apple doesn't have a environ symbol */
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+#elif !defined(__USE_GNU)
+/* when __USE_GNU is defined environ is defined in unistd.h
+ * this to avoid a redundant redeclaration */
+extern gchar **environ;
+#endif
 
 
+
 #ifdef HAVE_LIBSTARTUP_NOTIFICATION
 typedef struct
 {
