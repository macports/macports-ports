--- objects/custom/shape_info.c.org	2005-05-09 08:22:06.000000000 +0200
+++ objects/custom/shape_info.c	2005-05-09 08:22:16.000000000 +0200
@@ -116,7 +116,7 @@
 /* routine to chomp off the start of the string */
 #define path_chomp(path) while (path[0]!='\0'&&strchr(" \t\n\r,", path[0])) path++
 
-static void
+void
 parse_path(ShapeInfo *info, const char *path_str, DiaSvgGraphicStyle *s)
 {
   enum {
