--- malloc.c.orig	2005-06-15 12:19:14.000000000 -0700
+++ malloc.c	2005-06-15 12:19:28.000000000 -0700
@@ -38,19 +38,8 @@
 
 
 #include <stdio.h>
-#if linux /* daved - 0.19.0 */
 #include <stdlib.h>
-#endif
 #include <string.h>
-#if linux /* daved - 0.19.0 */
-#include <stdlib.h>
-#endif
-
-#if AMIGA
-#include <stdlib.h>
-#else
-#include <malloc.h>
-#endif
 
 #include "error.h"
 
