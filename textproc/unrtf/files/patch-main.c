--- main.c.orig	2005-06-15 12:19:03.000000000 -0700
+++ main.c	2005-06-15 12:19:09.000000000 -0700
@@ -45,9 +45,7 @@
 
 
 #include <stdio.h>
-#if linux || __DJGPP__ /* daved - 0.19.0, st001906 - 0.19.6 */
 #include <stdlib.h>
-#endif
 #include <string.h>
 
 #include "defs.h"
