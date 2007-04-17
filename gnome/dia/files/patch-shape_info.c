--- objects/custom/shape_info.c.orig	2007-01-06 23:28:09.000000000 +0100
+++ objects/custom/shape_info.c	2007-04-13 16:38:55.000000000 +0200
@@ -114,7 +114,7 @@
 }
 
 
-static void
+void
 parse_path(ShapeInfo *info, const char *path_str, DiaSvgStyle *s, const char* filename)
 {
   GArray *points;
