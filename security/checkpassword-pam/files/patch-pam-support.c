--- pam-support.c.orig	Wed Aug 11 17:34:14 2004
+++ pam-support.c	Wed Aug 11 17:34:16 2004
@@ -21,7 +21,15 @@
 
 #include "logging.h"
 
+#if defined(__APPLE__)
+#include <AvailabilityMacros.h>
+#endif
+
+#if defined(__APPLE__) && defined(MAC_OS_X_VERSION_MIN_REQUIRED) && (MAC_OS_X_VERSION_MIN_REQUIRED < 1060)
+#include <pam/pam_appl.h>
+#else
 #include <security/pam_appl.h>
+#endif
 #include <stdlib.h>
 #include <string.h>
 
