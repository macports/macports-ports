--- src/osdep/unix/env_unix.c-orig	Wed Nov  5 17:09:13 2003
+++ src/osdep/unix/env_unix.c	Wed Nov  5 17:11:16 2003
@@ -29,7 +29,7 @@
 static char *myMailboxDir = NIL;/* mailbox directory name */
 static char *myLocalHost = NIL;	/* local host name */
 static char *myNewsrc = NIL;	/* newsrc file name */
-static char *mailsubdir = NIL;	/* mail subdirectory name */
+static char *mailsubdir = "Mail";	/* mail subdirectory name */
 static char *sysInbox = NIL;	/* system inbox name */
 static char *newsActive = NIL;	/* news active file */
 static char *newsSpool = NIL;	/* news spool */
