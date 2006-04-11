--- rfc822.c.orig	2006-02-20 23:41:02.000000000 +0100
+++ rfc822.c	2006-04-11 23:17:08.000000000 +0200
@@ -1058,7 +1058,7 @@
 };
 /*}}}*/
 
-static struct zFile * zopen(const char *filename, const char *mode) {/*{{{*/
+static struct zFile * my_zopen(const char *filename, const char *mode) {/*{{{*/
   struct zFile *zf = new(struct zFile);
 
   zf->type = get_compression_type(filename);
@@ -1117,7 +1117,7 @@
     	fprintf(stderr, "Decompressing %s...\n", filename);
     }
 
-    zf = zopen(filename, "rb");
+    zf = my_zopen(filename, "rb");
     if (!zf) {
       fprintf(stderr, "Could not open %s\n", filename);
       *data = NULL;
