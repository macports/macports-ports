--- util.c.orig	2005-09-06 14:30:07.000000000 -0700
+++ util.c	2005-09-06 14:30:11.000000000 -0700
@@ -29,6 +29,7 @@
 
 #include <sys/stat.h>
 #include <sys/types.h>  /* Linux doesn't define mode_t, etc. in sys/stat.h. */
+#include <archive.h>
 #include <archive_entry.h>
 #include <ctype.h>
 #include <errno.h>
