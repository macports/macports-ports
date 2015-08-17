--- screen.c.orig	2009-01-21 12:06:11.000000000 +0800
+++ screen.c	2009-01-21 12:08:27.000000000 +0800
@@ -101,6 +101,11 @@
 
 #include "logfile.h"	/* islogfile, logfflush */
 
+#ifdef __APPLE__
+#include <vproc.h>
+#include "vproc_priv.h"
+#endif
+
 #ifdef DEBUG
 FILE *dfp;
 #endif
@@ -1211,6 +1216,11 @@
   freopen("/dev/null", "w", stderr);
   debug("-- screen.back debug started\n");
 
+#ifdef __APPLE__
+  if (_vprocmgr_move_subset_to_user(real_uid, "Background") != NULL)
+      errx(1, "can't migrate to background session");
+#endif
+
   /* 
    * This guarantees that the session owner is listed, even when we
    * start detached. From now on we should not refer to 'LoginName'
