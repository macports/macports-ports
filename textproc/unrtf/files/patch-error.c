--- error.c.orig	2005-06-15 12:18:28.000000000 -0700
+++ error.c	2005-06-15 12:18:35.000000000 -0700
@@ -39,9 +39,7 @@
 
 
 #include <stdio.h>
-#if linux || __DJGPP__ /* daved - 0.19.1, st001906 - 0.19.6 */
 #include <stdlib.h>
-#endif
 #include "defs.h"
 #include "main.h"
 
