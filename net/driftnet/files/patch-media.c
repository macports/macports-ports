--- media.c.orig	Mon Jul 14 10:31:39 2003
+++ media.c	Mon Jul 14 10:31:56 2003
@@ -9,6 +9,7 @@
 
 static const char rcsid[] = "$Id: media.c,v 1.6 2002/07/08 23:32:33 chris Exp $";
 
+#include <sys/types.h>
 #include <assert.h>
 #include <dirent.h>
 #include <fcntl.h>
