--- libs/ext/cothreads/cothreads/cothreads.c.org	Sun Dec 14 17:23:33 2003
+++ libs/ext/cothreads/cothreads/cothreads.c	Sun Dec 14 17:23:44 2003
@@ -20,6 +20,7 @@
  */
 
 #include "pth_p.h" /* this pulls in everything */
+#include <sys/time.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/resource.h>
