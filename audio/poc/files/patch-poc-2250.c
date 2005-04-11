--- poc-2250.c.orig	2005-04-03 07:41:11.000000000 -0400
+++ poc-2250.c	2005-04-03 07:41:42.000000000 -0400
@@ -380,7 +380,7 @@
   int i;
   for (i = optind; (i < argc) && !finished; i++) {
     assert(argv[i] != NULL);
-    unsigned char filename[MAX_FILENAME];
+    char filename[MAX_FILENAME];
     strncpy(filename, argv[i], MAX_FILENAME - 1);
     filename[MAX_FILENAME - 1] = '\0';
 
