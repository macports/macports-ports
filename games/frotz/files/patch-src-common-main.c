--- src/common/main.c.orig	Mon Jun 28 17:26:51 2004
+++ src/common/main.c	Mon Jun 28 17:27:21 2004
@@ -176,7 +176,7 @@
 
     init_memory ();
 
-    init_process ();
+    frotz_init_process ();
 
     init_sound ();
 
