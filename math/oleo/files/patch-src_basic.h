--- src/basic.h.orig	2000-08-10 15:02:49.000000000 -0600
+++ src/basic.h	2005-08-19 01:31:14.000000000 -0600
@@ -36,9 +36,6 @@
 
 extern const int colmagic[9];
 extern  const int rowmagic[9];
-extern char * motion_name[9];
-extern enum motion_magic complementary_motion[9];
-extern enum motion_magic opposite_motion[9];
 
 extern int run_load_hooks;
 
