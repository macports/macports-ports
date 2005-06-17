--- dotneato/common/renderprocs.h.org	Sat Dec 11 22:26:00 2004
+++ dotneato/common/renderprocs.h	Sat Apr  2 00:18:59 2005
@@ -107,6 +107,8 @@
     extern char *gd_alternate_fontlist(char *font);
     extern char *gd_textsize(textline_t * textline, char *fontname,
 			     double fontsz, char **fontpath);
+    extern char *quartz_textsize(textline_t * textline, char *fontname,
+			     double fontsz, char **fontpath);
     extern point gd_user_shape_size(node_t * n, char *shapeimagefile);
     extern point ps_user_shape_size(node_t * n, char *shapeimagefile);
     extern point svg_user_shape_size(node_t * n, char *shapeimagefile);
