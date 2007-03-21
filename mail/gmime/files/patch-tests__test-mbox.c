--- tests/test-mbox.c	2007-02-08 05:18:31.000000000 +0000
+++ tests/test-mbox.c	2007-03-04 12:59:52.000000000 +0000
@@ -18,6 +18,10 @@
  */
 
 
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
