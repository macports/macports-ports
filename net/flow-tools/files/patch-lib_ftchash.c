--- lib/ftchash.c.orig	Mon Oct  2 12:30:55 2006
+++ lib/ftchash.c	Mon Oct  2 12:31:29 2006
@@ -326,7 +326,7 @@
       (char*)ftch->traverse_chunk->base+ftch->traverse_chunk->next) {
 
       ret = ftch->traverse_rec;
-      (char*)ftch->traverse_rec += ftch->d_size;
+      ftch->traverse_rec = (char *)ftch->traverse_rec + ftch->d_size;
       return ret;
 
     } else {
