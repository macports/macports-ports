--- work/midgard-php4-1.7.3/midgard.c	2005-11-22 13:54:42.000000000 +0200
+++ midgard.c	2005-12-11 15:00:15.000000000 +0200
@@ -34,7 +34,7 @@
 #include <http_config.h>
 
 #ifdef MIDGARD_APXS2
-#include <apr_compat.h>
+	/*#include <apr_compat.h>*/
 #include <apr_strings.h>
 #endif
 
