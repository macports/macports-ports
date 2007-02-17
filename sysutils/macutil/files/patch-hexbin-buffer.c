--- hexbin/buffer.c.org        2005-02-01 23:57:21.489383480 -0600
+++ hexbin/buffer.c     2005-02-02 00:00:23.574583423 -0600
@@ -1,12 +1,11 @@
+
+#include <stdlib.h>
+
 #include "globals.h"
 #include "../util/util.h"
 #include "buffer.h"
 #include "../fileio/wrfile.h"
 
-extern char *malloc();
-extern char *realloc();
-extern void exit();
-
 char *data_fork, *rsrc_fork;
 int data_size, rsrc_size;
 static int max_data_size, max_rsrc_size;
