diff -Naur xmlcatalog.c xmlcatalog.c
--- xmlcatalog.c	Fri Mar 22 12:35:22 2002
+++ xmlcatalog.c	Sun Jul 14 16:11:06 2002
@@ -41,7 +41,7 @@
 
 #ifdef LIBXML_CATALOG_ENABLED
 
-#define XML_SGML_DEFAULT_CATALOG "/etc/sgml/catalog"
+#define XML_SGML_DEFAULT_CATALOG "@PREFIX@/etc/sgml/catalog"
 
 /************************************************************************
  * 									*
