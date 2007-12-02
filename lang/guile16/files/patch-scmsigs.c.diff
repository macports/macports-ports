--- libguile/scmsigs.c.sav	Tue Feb 11 22:07:54 2003
+++ libguile/scmsigs.c	Tue Feb 11 22:08:18 2003
@@ -66,7 +66,7 @@
 /* The thread system has its own sleep and usleep functions.  */
 #ifndef USE_THREADS
 
-#if defined(MISSING_SLEEP_DECL)
+#if defined(MISSING_SLEEP_DECL) && ! defined(macosx)
 int sleep ();
 #endif
 
