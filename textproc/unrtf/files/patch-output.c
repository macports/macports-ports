--- output.c.orig	Thu Sep  9 21:09:49 2004
+++ output.c	Thu Sep  9 21:10:03 2004
@@ -36,9 +36,7 @@
 
 #include <stdio.h>
 #include <string.h>
-#if linux /* daved - 0.19.0 */
 #include <stdlib.h>
-#endif
 #include "malloc.h"
 #include "defs.h"
 #include "error.h"
