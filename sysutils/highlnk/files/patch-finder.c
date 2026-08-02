--- finder.c	Wed Aug 18 02:29:22 2004
+++ finder.c.new	Wed Aug 18 13:49:44 2004
@@ -7,7 +7,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <dirent.h>
-#include <linux/limits.h>
+#include <sys/syslimits.h>
 
 #include "md5.h"
 #include "finder.h"
