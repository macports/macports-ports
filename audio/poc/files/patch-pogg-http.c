--- pogg-http.c.orig	2005-04-03 07:52:38.000000000 -0400
+++ pogg-http.c	2005-04-03 07:52:53.000000000 -0400
@@ -588,7 +588,7 @@
    int i;
    for (i=optind; (i<argc) && !finished; i++) {
      assert(argv[i] != NULL);
-     unsigned char filename[MAX_FILENAME];
+     char filename[MAX_FILENAME];
      strncpy(filename, argv[i], MAX_FILENAME - 1);
      filename[MAX_FILENAME - 1] = '\0';
 
