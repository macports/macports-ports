--- squirrel/sqmem.cpp	Wed May  5 19:22:11 2004
+++ sqmem.cpp	Mon Nov  1 13:34:41 2004
@@ -2,7 +2,7 @@
 	see copyright notice in squirrel.h
 */
 #include "sqpcheader.h"
-#include <malloc.h>
+#include <stdlib.h>
 void *sq_vm_malloc(unsigned int size){	return malloc(size); }
 
 void *sq_vm_realloc(void *p, unsigned int oldsize, unsigned int size){ return realloc(p, size); }
