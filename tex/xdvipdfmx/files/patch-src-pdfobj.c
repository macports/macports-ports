--- src/pdfobj.c.orig	2006-04-12 14:13:11.000000000 +0900
+++ src/pdfobj.c	2006-04-12 14:13:41.000000000 +0900
@@ -2203,6 +2203,7 @@
     xref_table[i].direct   = NULL;
     xref_table[i].indirect = NULL;
     xref_table[i].used     = 0;
+    xref_table[i].generation    = 0;
     xref_table[i].file_position = 0L;
   }
   num_input_objects = new_size;
