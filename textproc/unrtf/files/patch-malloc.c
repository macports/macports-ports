--- malloc.c.orig	Thu Sep  9 21:07:49 2004
+++ malloc.c	Thu Sep  9 21:07:58 2004
@@ -39,15 +39,7 @@
 
 #include <stdio.h>
 #include <string.h>
-#if linux /* daved - 0.19.0 */
 #include <stdlib.h>
-#endif
-
-#if AMIGA
-#include <stdlib.h>
-#else
-#include <malloc.h>
-#endif
 
 #include "error.h"
 
