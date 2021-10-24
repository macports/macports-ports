--- headers.c.orig	2010-08-09 15:35:19.000000000 -0500
+++ headers.c	2012-05-13 21:33:41.000000000 -0500
@@ -29,6 +29,7 @@
 #include <stdio.h>
 #include <stdarg.h>
 #include <string.h>
+#include <strings.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <time.h>
@@ -171,7 +172,7 @@
     {
 #ifdef HAVE_GETTIMEOFDAY
       if (gettimeofday (&tv, NULL) != -1) /* This shouldn't fail ... */
-	snprintf (buf, sizeof buf, "%ld.%ld.%d@%s", tv.tv_sec, tv.tv_usec,
+	snprintf (buf, sizeof buf, "%ld.%d.%d@%s", tv.tv_sec, tv.tv_usec,
 		  getpid (), message->session->localhost);
       else /* ... but if it does fall back to using time() */
 #endif
