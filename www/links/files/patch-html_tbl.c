--- html_tbl.c.orig	Sun Jan  2 13:17:25 2005
+++ html_tbl.c	Thu Feb 17 18:22:59 2005
@@ -41,6 +41,8 @@
 #define R_ALL		3
 #define R_GROUPS	4
 
+struct table;
+
 /* prototype */
 void get_align(char *, int *);
 void get_valign(char *, int *);
