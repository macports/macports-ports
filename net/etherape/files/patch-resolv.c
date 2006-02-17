--- src/resolv.c.org	2005-12-30 08:36:09.000000000 -0800
+++ src/resolv.c	2006-02-16 22:37:51.000000000 -0800
@@ -27,6 +27,8 @@
 #include "config.h"
 #endif
 
+#include <stdint.h>
+#include <sys/types.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
