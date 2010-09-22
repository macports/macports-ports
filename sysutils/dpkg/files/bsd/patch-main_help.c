--- src/help.c.old	Thu Dec  9 16:35:16 2004
+++ src/help.c	Thu Dec  9 16:35:38 2004
@@ -77,12 +77,11 @@
 
 void checkpath(void) {
 /* Verify that some programs can be found in the PATH. */
-  static const char *const checklist[]= { "ldconfig", 
+  static const char *const checklist[]= {
 #if WITH_START_STOP_DAEMON
     "start-stop-daemon",
 #endif    
     "install-info",
-    "update-rc.d",
     NULL
   };
 
