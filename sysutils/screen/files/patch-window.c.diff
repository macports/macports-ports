--- window.c	2014-04-26 12:58:35.000000000 +0200
+++ window.c	2014-05-01 21:36:54.000000000 +0200
@@ -33,6 +33,7 @@
 #include <sys/stat.h>
 #include <signal.h>
 #include <fcntl.h>
+#include <unistd.h>
 #ifndef sun
 # include <sys/ioctl.h>
 #endif
@@ -1660,6 +1661,38 @@
   return r;
 }
 
+#ifdef RUN_LOGIN
+/*
+ * All of the logic to maintain utmpx is now built into /usr/bin/login, so
+ * all we need to do is call it, and pass the shell command to it.
+ */
+extern char *LoginName;
+
+static int
+run_login(const char *path, char *const argv[], char *const envp[])
+{
+    const char *shargs[MAXARGS + 1 + 3];
+    const char **fp, **tp;
+
+    if (access(path, X_OK) < 0)
+        return -1;
+    shargs[0] = "login";
+    shargs[1] = (*argv[0] == '-') ? "-pfq" : "-pflq";
+    shargs[2] = LoginName;
+    shargs[3] = path;
+    fp = (const char **)argv + 1;
+    tp = shargs + 4;
+    /* argv has already been check for length */
+    while ((*tp++ = *fp++) != NULL) {}
+    /* shouldn't return unless there was an error */
+    return (execve("/usr/bin/login", (char *const*)shargs, envp));
+}
+
+/* replace the following occurrences of execve() with run_login() */
+#define execve run_login
+
+#endif /* RUN_LOGIN */
+
 void
 FreePseudowin(w)
 struct win *w;
