--- misc/stream.c.orig	2005-04-04 06:36:15.000000000 -0400
+++ misc/stream.c	2005-04-04 06:36:22.000000000 -0400
@@ -7,6 +7,7 @@
 
 #include <stdarg.h>
 #include <stdlib.h>
+#include <string.h>
 #if defined( INC_ALL )
   #include "stream.h"
 #elif defined( INC_CHILD )
