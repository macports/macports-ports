--- converter/other/cameratopam/camera.c.orig	2005-10-01 11:25:12.000000000 -0400
+++ converter/other/cameratopam/camera.c	2005-10-01 11:26:32.000000000 -0400
@@ -4,6 +4,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <assert.h>
+#include <sys/types.h>
 #include <netinet/in.h>
 
 #ifdef HAVE_JPEG
