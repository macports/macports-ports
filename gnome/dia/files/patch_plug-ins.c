--- plug-ins/xslt/xslt.h.orig	Tue Dec  2 20:24:37 2003
+++ plug-ins/xslt/xslt.h	Tue Dec  2 20:24:52 2003
@@ -53,11 +53,11 @@
 } fromxsl_t;
 
 /* Possible stylesheets */
-fromxsl_t *froms;
+extern fromxsl_t *froms;
 
 /* Selected stylesheets */
-toxsl_t *xsl_to;
-fromxsl_t *xsl_from;
+extern toxsl_t *xsl_to;
+extern fromxsl_t *xsl_from;
 
 void xslt_dialog_create();
 void xslt_ok();
--- plug-ins/xslt/xslt.c.orig	Tue Dec  2 20:25:06 2003
+++ plug-ins/xslt/xslt.c	Tue Dec  2 20:25:24 2003
@@ -39,6 +39,12 @@
 #include "xslt.h"
 
 void xslt_ok(void);
+/* Possible stylesheets */
+fromxsl_t *froms;
+
+/* Selected stylesheets */
+toxsl_t *xsl_to;
+fromxsl_t *xsl_from;
 
 static char *diafilename;
 static char *filename;
