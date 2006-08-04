--- mpage.h.orig	2004-05-30 13:41:43.000000000 -0600
+++ mpage.h	2006-08-04 00:39:09.000000000 -0600
@@ -167,6 +167,16 @@
 # define	PS_FLAG2	"-Adobe-"
 
 /*
+ * Structure to describe a physical piece of paper, e.g. A4 or Letter
+ */
+struct page_desc {
+    char *media;
+    int width;
+    int height;
+};
+    
+
+/*
  * some basic PS parameters
  */
 extern int ps_width;	/* number of points in the X direction (8.5 inches) */
@@ -213,16 +223,6 @@
 };
 
 
-/*
- * Structure to describe a physical piece of paper, e.g. A4 or Letter
- */
-struct page_desc {
-    char *media;
-    int width;
-    int height;
-};
-    
-
 /* array of sheets where pages are ordered for coli ??? */
 extern struct sheet coli[];
 
