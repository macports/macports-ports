--- poc-3119.c.orig	2005-04-03 07:49:25.000000000 -0400
+++ poc-3119.c	2005-04-03 07:49:43.000000000 -0400
@@ -435,7 +435,7 @@
   int i;
   for (i = optind; (i < argc) && !finished; i++) {
     assert(argv[i] != NULL);
-    unsigned char filename[MAX_FILENAME];
+    char filename[MAX_FILENAME];
     strncpy(filename, argv[i], MAX_FILENAME - 1);
     filename[MAX_FILENAME - 1] = '\0';
 
