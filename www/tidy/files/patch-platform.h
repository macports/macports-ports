--- platform.h.orig	Thu Jan 13 07:19:19 2000
+++ platform.h	Mon Mar 27 16:31:20 2000
@@ -17,9 +17,8 @@
   It enables tidy to find config files named ~/.tidyrc
   and ~your/.tidyrc etc if the HTML_TIDY environment
   variable is not set. Contributed by Todd Lewis.
-
-#define SUPPORT_GETPWNAM
 */
+#define SUPPORT_GETPWNAM
 
 #include <ctype.h>
 #include <stdio.h>
