diff -ru jdk.orig/src/share/bin/java.c jdk/src/share/bin/java.c
--- jdk.orig/src/share/bin/java.c	2009-05-15 01:02:24.000000000 -0700
+++ jdk/src/share/bin/java.c	2009-05-15 01:10:27.000000000 -0700
@@ -1144,7 +1144,7 @@
             printXUsage = JNI_TRUE;
             return JNI_TRUE;
 #ifdef __APPLE__
-        } else if (JLI_StrCmp(arg, "-XstartOnFirstThread") == 0) {
+        } else if (strcmp(arg, "-XstartOnFirstThread") == 0) {
             continueInSameThread = JNI_TRUE;
 #endif            
 /*
