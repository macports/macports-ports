--- output.c.orig	2005-06-15 12:18:45.000000000 -0700
+++ output.c	2005-06-15 12:18:51.000000000 -0700
@@ -36,9 +36,7 @@
 
 
 #include <stdio.h>
-#if linux || __DJGPP__ /* daved - 0.19.0,  st001906 - 0.19.6 */
 #include <stdlib.h>
-#endif
 #include <string.h>
 #include "malloc.h"
 #include "defs.h"
