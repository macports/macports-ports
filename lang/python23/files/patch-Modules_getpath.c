--- Modules/getpath.c.orig	Thu Feb  5 15:43:59 2004
+++ Modules/getpath.c	Thu Feb  5 15:48:35 2004
@@ -374,6 +374,9 @@
 #ifdef WITH_NEXT_FRAMEWORK
     NSModule pythonModule;
 #endif
+#ifdef __APPLE__
+    unsigned long nsexeclength = MAXPATHLEN;
+#endif
 
 	/* If there is no slash in the argv0 path, then we have to
 	 * assume python is on the user's $PATH, since there's no
@@ -382,6 +385,20 @@
 	 */
 	if (strchr(prog, SEP))
 		strncpy(progpath, prog, MAXPATHLEN);
+#ifdef __APPLE__
+	/* On Mac OS X, if a script uses an interpreter of the form
+	 * "#!/opt/python2.3/bin/python", the kernel only passes "python"
+	 * as argv[0], which falls through to the $PATH search below.
+	 * If /opt/python2.3/bin isn't in your path, or is near the end,
+	 * this algorithm may incorrectly find /usr/bin/python. To work
+	 * around this, we can use _NSGetExecutablePath to get a better
+	 * hint of what the intended interpreter was, although this
+	 * will fail if a relative path was used. but in that case,
+	 * absolutize() should help us out below
+	 */
+	else if(0 == _NSGetExecutablePath(progpath, &nsexeclength) && progpath[0] == SEP)
+	  ;
+#endif // __APPLE__
 	else if (path) {
 		while (1) {
 			char *delim = strchr(path, DELIM);
