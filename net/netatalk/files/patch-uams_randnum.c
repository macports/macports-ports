--- etc/uams/uams_randnum.c	Thu Oct 28 17:28:54 2004
+++ etc/uams/uams_randnum.c.new	Thu Oct 28 17:28:43 2004
@@ -50,7 +50,7 @@
 #include <des.h>
 
 #ifdef USE_CRACKLIB
-#include <crack.h>
+#include <packer.h>
 #endif /* USE_CRACKLIB */
 
 #ifndef __inline__
