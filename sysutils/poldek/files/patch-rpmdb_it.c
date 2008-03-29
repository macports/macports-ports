--- pm/rpm//rpmdb_it.c.orig	2008-02-24 23:14:08.000000000 +0100
+++ pm/rpm//rpmdb_it.c	2008-03-29 13:24:07.000000000 +0100
@@ -18,6 +18,10 @@
 # include "config.h"
 #endif
 
+#ifdef __APPLE__
+#include <sys/param.h>
+#endif
+
 #define ENABLE_TRACE 0
 #include "i18n.h"
 #include "misc.h"
