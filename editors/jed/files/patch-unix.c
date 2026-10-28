--- src/unix.c.orig	2009-12-14 03:12:55.000000000 +0100
+++ src/unix.c	2010-05-24 10:42:14.000000000 +0200
@@ -211,8 +211,19 @@
      {
 	pid_t pid = getpid ();
 	Startup_PGID = getpgid (pid);
-	(void) tcsetpgrp (Read_FD, pid);
-	(void) setpgid (pid, pid);
+	if (-1 == tcsetpgrp (Read_FD, pid))
+	  {
+	     fprintf (stderr, "tcsetpgrp failed\n");
+	     Terminal_PGID = -1;
+	     return;
+	  }
+	if (-1 == setpgid (pid, pid))
+	  {
+	     fprintf (stderr, "setpgid failed\n");
+	     (void) tcsetpgrp (Read_FD, Startup_PGID);
+	     Terminal_PGID = -1;
+	     return;
+	  }
      }
 #endif
 }
