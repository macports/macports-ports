--- io.c.orig	Fri Mar  8 02:34:42 1996
+++ io.c	Wed Dec 20 05:19:17 2000
@@ -1193,10 +1193,16 @@
 #endif
 		);
 	tfname = copystr(buf);
+#ifdef NO_MKSTEMP
 	tfname = mktemp(tfname);
+#endif
 #ifndef MSFILESYSTEM
+#ifndef NO_MKSTEMP
+	tmpfd = mkstemp(tfname);
+#else
 	(void) close(creat(tfname, 0600));
 	tmpfd = open(tfname, 2);
+#endif
 #else /* MSFILESYSTEM */
 	tmpfd = open(tfname, O_CREAT|O_EXCL|O_BINARY|O_RDWR, S_IWRITE|S_IREAD);
 #endif /* MSFILESYSTEM */
