--- lib/ftfile.c.orig	Thu Feb 13 05:38:42 2003
+++ lib/ftfile.c	Fri Feb 10 10:39:40 2006
@@ -311,7 +311,7 @@
 int ftfile_expire (struct ftfile_entries *fte, int doit, int curbytes)
 {
   u_int i;
-  struct ftfile_entry *n1;
+  struct ftfile_entry *n1, *n2;
   u_int64 bytes;
 
   /*
@@ -323,15 +323,20 @@
   bytes = 0;
 
   if (fte->max_files && (fte->num_files > fte->max_files)) {
+    n2 = NULL;
     FT_TAILQ_FOREACH(n1, &fte->head, chain) {
+      if (n2 != NULL) {
+	ftfile_entry_free(n2);
+	n2 = NULL;
+      }
       fterr_info("remove/1 %s", n1->name);
       bytes += n1->size;
       ++i;
       if (doit) {
+        n2 = n1;
         FT_TAILQ_REMOVE(&fte->head, n1, chain);
         if (unlink(n1->name) == -1) 
           fterr_warn("unlink(%s)", n1->name);
-        ftfile_entry_free(n1);
       } /* doit */
       if ((fte->num_files - i) <= fte->max_files)
         break;
@@ -340,6 +345,10 @@
       fte->num_files -= i;
       fte->num_bytes -= bytes;
     } /* doit */
+    if (n2 != NULL) {
+      ftfile_entry_free(n2);
+      n2 = NULL;
+    }
   } /* if */
 
   if (debug)
@@ -354,15 +363,20 @@
    */
 
   if (fte->max_bytes && (fte->num_bytes+curbytes > fte->max_bytes)) {
+    n2 = NULL;
     FT_TAILQ_FOREACH(n1, &fte->head, chain) {
+      if (n2 != NULL) {
+	ftfile_entry_free(n2);
+	n2 = NULL;
+      }
       fterr_info("remove/2 %s", n1->name);
       bytes += n1->size;
       ++i;
       if (doit) {
+        n2 = n1;
         FT_TAILQ_REMOVE(&fte->head, n1, chain);
         if (unlink(n1->name) == -1) 
           fterr_warn("unlink(%s)", n1->name);
-        ftfile_entry_free(n1);
       } /* doit */
       if ((fte->num_bytes+curbytes - bytes) <= fte->max_bytes)
         break;
@@ -371,6 +385,10 @@
       fte->num_files -= i;
       fte->num_bytes -= bytes;
     } /* doit */
+    if (n2 != NULL) {
+      ftfile_entry_free(n2);
+      n2 = NULL;
+    }
   } /* if */
 
   if (debug)
@@ -762,13 +780,19 @@
 {
   struct ftfile_entry *n1, *n2;
 
+  n2 = NULL;
   FT_TAILQ_FOREACH(n1, &fte->head, chain) {
+    if (n2 != NULL) {
+      ftfile_entry_free(n2);
+      n2 = NULL;
+    }
     FT_TAILQ_REMOVE(&fte->head, n1, chain);
     n2 = n1;
-    n1 = FT_TAILQ_NEXT(n1, chain);
+  }
+
+  if (n2 != NULL) {
     ftfile_entry_free(n2);
-    if (!n1)
-      break;
+    n2 = NULL;
   }
 
 } /* ftfile_free */
