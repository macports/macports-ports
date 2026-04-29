--- 9e.c.orig	2009-06-14 02:51:47.000000000 -0700
+++ 9e.c	2009-06-14 02:52:33.000000000 -0700
@@ -4,6 +4,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <sys/stat.h>
@@ -144,7 +145,7 @@
       fout = NULL;
     } else {
       if (Verbose)
-	fprintf(stderr, "%s %d\n", namebuf, size);
+	fprintf(stderr, "%s %ld\n", namebuf, size);
       if(mode & CHDIR) {
         assert(size == 0);
 	/* Give ourselves read, write, and execute permission */
