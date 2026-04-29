--- ./util/ulocks.c.orig	2005-06-30 21:17:27.000000000 +0200
+++ ./util/ulocks.c	2012-04-23 17:56:39.446509872 +0200
@@ -93,7 +93,7 @@
 {
 
   if(lockf(lock, F_LOCK, 0) < 0)
-    return nerr_raise_errno (NERR_LOCK, "File lock failed");
+    return nerr_raise_errno (NERR_LOCK, "%s", "File lock failed");
 
   return STATUS_OK;
 }
