--- template.c.orig	2004-11-19 01:05:10.000000000 +0100
+++ template.c	2007-06-25 15:55:39.000000000 +0200
@@ -35,7 +35,6 @@
   
   if (!t) return;
   if (t->name) {
-    fprintf(stderr, "tpl_delete - name\n");
     free(t->name);
     t->name = 0;
   }
@@ -43,7 +42,6 @@
     tmp = n->next;
     tpl_node_delete(n);
   }
-  fprintf(stderr, "tpl_delete\n");
   free(t);
  
 }
