--- rec.c.orig	Fri Mar  8 02:34:43 1996
+++ rec.c	Wed Dec 20 05:19:50 2000
@@ -55,8 +55,12 @@
 #endif
 		);
 	recfname = copystr(buf);
+#ifndef NO_MKSTEMP
+	rec_fd = mkstemp(recfname);
+#else
 	recfname = mktemp(recfname);
 	rec_fd = creat(recfname, 0644);
+#endif
 	if (rec_fd == -1) {
 		complain("Cannot create \"%s\"; recovery disabled.", recfname);
 		/*NOTREACHED*/
