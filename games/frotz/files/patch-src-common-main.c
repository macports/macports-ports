--- src/common/main.c.orig	2015-05-20 03:52:15.000000000 -0500
+++ src/common/main.c	2018-10-06 21:05:10.000000000 -0500
@@ -155,7 +155,7 @@
 
     init_memory ();
 
-    init_process ();
+    frotz_init_process ();
 
     init_sound ();
 
