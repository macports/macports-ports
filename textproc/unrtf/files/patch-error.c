--- error.c.orig	Thu Sep  9 21:10:18 2004
+++ error.c	Thu Sep  9 21:10:36 2004
@@ -38,9 +38,7 @@
 
 
 #include <stdio.h>
-#if linux /* daved - 0.19.1 */
 #include <stdlib.h>
-#endif
 
 #include "defs.h"
 #include "main.h"
