--- test/bjc-unprint.c.orig	Fri Mar 26 08:34:31 2004
+++ test/bjc-unprint.c	Fri Mar 26 08:34:48 2004
@@ -28,7 +28,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
+#ifdef HAVE_MALLOC_H
 #include <malloc.h>
+#endif
 
 
 char *outfilename= 0;
