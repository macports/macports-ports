--- ./util/neo_files.c.orig	2007-07-12 04:14:23.000000000 +0200
+++ ./util/neo_files.c	2012-04-23 17:50:13.873212371 +0200
@@ -216,7 +216,7 @@
   NEOERR *err = STATUS_OK;
 
   if (files == NULL) 
-    return nerr_raise(NERR_ASSERT, "Invalid call to ne_listdir_fmatch");
+    return nerr_raise(NERR_ASSERT, "%s", "Invalid call to ne_listdir_fmatch");
 
   if (*files == NULL)
   {
