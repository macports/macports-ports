--- screen.c	2014-04-26 18:22:09.000000000 +0200
+++ screen.c	2014-05-01 21:36:54.000000000 +0200
@@ -109,6 +109,11 @@
 
 #include "logfile.h"	/* islogfile, logfflush */
 
+#ifdef __APPLE__
+#include <vproc.h>
+#include <vproc_priv.h>
+#endif
+
 #ifdef DEBUG
 FILE *dfp;
 #endif
@@ -1046,6 +1051,16 @@
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
@@ -1314,6 +1329,11 @@
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
