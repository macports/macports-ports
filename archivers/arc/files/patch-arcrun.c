--- arcrun.c.orig	2005-04-04 06:50:02.000000000 -0400
+++ arcrun.c	2005-04-04 06:50:12.000000000 -0400
@@ -19,6 +19,7 @@
  * Language: Computer Innovations Optimizing C86
  */
 #include <stdio.h>
+#include <string.h>
 #include "arc.h"
 
 VOID	rempath(), openarc(), closearc(), arcdie();
