--- highlnk.c	Wed Aug 18 02:29:22 2004
+++ highlnk.c.new	Wed Aug 18 13:50:22 2004
@@ -6,7 +6,7 @@
 
 #include <stdio.h>
 #include <unistd.h>
-#include <linux/limits.h>
+#include <sys/syslimits.h>
 
 #include "md5.h"
 #include "highlnk.h"
