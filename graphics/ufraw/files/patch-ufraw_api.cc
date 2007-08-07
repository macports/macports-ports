--- dcraw_api.cc-dist   2007-08-06 12:40:36.000000000 -0400
+++ dcraw_api.cc        2007-08-06 12:41:49.000000000 -0400
@@ -23,6 +23,15 @@
 #include <float.h>
 #include <glib.h>
 #include <glib/gi18n.h> /*For _(String) definition - NKBJ*/
+
+/* For ufraw config.h */
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
+#ifdef HAVE_SYS_TYPES_H 
+#include <sys/types.h> /*For off_t */
+#endif
 #include "dcraw_api.h"
 #include "dcraw.h"
 

