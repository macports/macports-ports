--- source/setenv.c.old	Wed Jan 14 00:26:19 2004
+++ source/setenv.c	Wed Jan 14 00:27:35 2004
@@ -39,7 +39,11 @@
  */
 int
 setenv(name, value, rewrite)
+#ifdef __APPLE__
+    const char *name, *value;
+#else
 	register char *name, *value;
+#endif
 	int rewrite;
 {
 	extern char **environ;
@@ -97,7 +101,11 @@
  */
 void
 unsetenv(name)
+#ifdef __APPLE__
+    const char	*name;
+#else
 	char	*name;
+#endif
 {
 	extern char **environ;
 	register char **P;
