--- gas/listing.c.orig	2009-06-26 12:41:45.000000000 -0700
+++ gas/listing.c	2009-06-26 12:42:04.000000000 -0700
@@ -1100,7 +1100,7 @@
   int pos = strlen (field_name);
   char **p;
 
-  fprintf (list_file, field_name);
+  fprintf (list_file, "%s", field_name);
   for (p = &argv[1]; *p != NULL; p++)
     if (**p == '-')
       {
