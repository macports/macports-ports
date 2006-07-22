--- u_fonts.h.orig	2006-07-22 12:51:10.000000000 +0900
+++ u_fonts.h	2006-07-22 12:51:45.000000000 +0900
@@ -32,9 +32,6 @@
 
 extern int		psfontnum();
 extern int		latexfontnum();
-extern struct _xfstruct	x_fontinfo[], x_backup_fontinfo[];
-extern struct _fstruct	ps_fontinfo[];
-extern struct _fstruct	latex_fontinfo[];
 
 /* element of linked list for each font
    The head of list is for the different font NAMES,
@@ -61,5 +58,9 @@
 				 * sizes */
 };
 
+extern struct _xfstruct	x_fontinfo[], x_backup_fontinfo[];
+extern struct _fstruct	ps_fontinfo[];
+extern struct _fstruct	latex_fontinfo[];
+
 int		x_fontnum();
 #endif /* U_FONTS_H */
