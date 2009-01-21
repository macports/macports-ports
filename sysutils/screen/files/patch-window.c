--- window.c.orig	2009-01-21 12:09:29.000000000 +0800
+++ window.c	2009-01-21 12:14:04.000000000 +0800
@@ -25,6 +25,7 @@
 #include <sys/stat.h>
 #include <signal.h>
 #include <fcntl.h>
+#include <unistd.h>
 #ifndef sun
 # include <sys/ioctl.h>
 #endif
@@ -1387,6 +1388,38 @@
   return pid;
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
 execvpe(prog, args, env)
 char *prog, **args, **env;
