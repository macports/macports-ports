--- main/help.c.old	Thu Dec  9 16:35:16 2004
+++ main/help.c	Thu Dec  9 16:35:38 2004
@@ -69,11 +69,11 @@
 
 void checkpath(void) {
 /* Verify that some programs can be found in the PATH. */
-  static const char *const checklist[]= { "ldconfig", 
+  static const char *const checklist[]= {
 #ifdef USE_START_STOP_DAEMON
     "start-stop-daemon",
 #endif    
-    "install-info", "update-rc.d", 0
+    "install-info", 0
   };
 
   struct stat stab;
