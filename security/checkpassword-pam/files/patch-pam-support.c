--- pam-support.c.orig	Wed Aug 11 17:34:14 2004
+++ pam-support.c	Wed Aug 11 17:34:16 2004
@@ -21,7 +21,11 @@
 
 #include "logging.h"
 
+#ifdef __APPLE__
+#include <pam/pam_appl.h>
+#else
 #include <security/pam_appl.h>
+#endif
 #include <stdlib.h>
 #include <string.h>
 
