--- client/util.c	Mon Dec 20 17:14:59 2004
+++ ../../util.c	Mon Dec 20 21:59:40 2004
@@ -11,6 +11,7 @@
 #include "client.h"
 #include <setjmp.h>
 #include <stdlib.h>
+#include <stdint.h>
 
 char *env_dir    = (char*)0;
 char *env_myport = (char*)0;
