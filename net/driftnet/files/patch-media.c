--- media.c.orig	Mon Jul 14 10:31:39 2003
+++ media.c	Mon Jul 14 10:31:56 2003
@@ -9,6 +9,7 @@
 
 static const char rcsid[] = "$Id: patch-media.c,v 1.1 2003/07/14 16:41:51 gwright Exp $";
 
+#include <sys/types.h>
 #include <assert.h>
 #include <dirent.h>
 #include <fcntl.h>
