--- poc-fec.c.orig	2005-04-03 07:50:23.000000000 -0400
+++ poc-fec.c	2005-04-03 07:50:37.000000000 -0400
@@ -397,7 +397,7 @@
   int i;
   for (i = optind; (i < argc) && !finished; i++) {
     assert(argv[i] != NULL);
-    unsigned char filename[MAX_FILENAME];
+    char filename[MAX_FILENAME];
     strncpy(filename, argv[i], MAX_FILENAME - 1);
     filename[MAX_FILENAME - 1] = '\0';
     
