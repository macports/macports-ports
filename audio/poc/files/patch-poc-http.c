--- poc-http.c.orig	2005-04-03 07:51:03.000000000 -0400
+++ poc-http.c	2005-04-03 07:51:12.000000000 -0400
@@ -559,7 +559,7 @@
    int i;
    for (i=optind; (i<argc) && !finished; i++) {
      assert(argv[i] != NULL);
-     unsigned char filename[MAX_FILENAME];
+     char filename[MAX_FILENAME];
      strncpy(filename, argv[i], MAX_FILENAME - 1);
      filename[MAX_FILENAME - 1] = '\0';
 
