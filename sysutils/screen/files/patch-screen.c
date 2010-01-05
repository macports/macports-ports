--- screen.c    2003-09-08 07:26:41.000000000 -0700
+++ screen.c    2009-02-13 12:05:05.000000000 -0800
@@ -101,6 +101,11 @@
 
 #include "logfile.h"   /* islogfile, logfflush */
 
+#ifdef __APPLE__
+#include <vproc.h>
+#include <vproc_priv.h>
+#endif
+
 #ifdef DEBUG
 FILE *dfp;
 #endif
@@ -929,6 +934,16 @@
    Panic(0, "No $SCREENDIR with multi screens, please.");
 #endif
     }
+#ifdef __APPLE__
+    else if (!multi && real_uid == eff_uid) {
+      static char DarwinSockDir[PATH_MAX];
+      if (confstr(_CS_DARWIN_USER_TEMP_DIR, DarwinSockDir, sizeof(DarwinSockDir))) {
+       strlcat(DarwinSockDir, ".screen", sizeof(DarwinSockDir));
+       SockDir = DarwinSockDir;
+      }
+    }
+#endif /* __APPLE__ */
+
 #ifdef MULTIUSER
   if (multiattach)
     {
@@ -1211,6 +1226,11 @@
   freopen("/dev/null", "w", stderr);
   debug("-- screen.back debug started\n");
 
+#ifdef __APPLE__
+       if (_vprocmgr_detach_from_console(0) != NULL)
+               errx(1, "can't detach from console");
+#endif
+
   /* 
    * This guarantees that the session owner is listed, even when we
    * start detached. From now on we should not refer to 'LoginName'

