--- bin/afppasswd/afppasswd.c	Thu Oct 28 17:29:41 2004
+++ bin/afppasswd/afppasswd.c.new	Thu Oct 28 17:29:34 2004
@@ -45,7 +45,7 @@
 #include <des.h>
 
 #ifdef USE_CRACKLIB
-#include <crack.h>
+#include <packer.h>
 #endif /* USE_CRACKLIB */
 
 #define OPT_ISROOT  (1 << 0)
