diff -Naur catalog.c libxml2-2.4.23.new/catalog.c
--- catalog.c	Tue Mar 19 04:37:54 2002
+++ catalog.c	Sun Jul 14 16:11:01 2002
@@ -56,10 +56,10 @@
 #define XML_URN_PUBID "urn:publicid:"
 #define XML_CATAL_BREAK ((xmlChar *) -1)
 #ifndef XML_XML_DEFAULT_CATALOG
-#define XML_XML_DEFAULT_CATALOG "file:///etc/xml/catalog"
+#define XML_XML_DEFAULT_CATALOG "file://@PREFIX@/etc/xml/catalog"
 #endif
 #ifndef XML_SGML_DEFAULT_CATALOG
-#define XML_SGML_DEFAULT_CATALOG "file:///etc/sgml/catalog"
+#define XML_SGML_DEFAULT_CATALOG "file://@PREFIX@/etc/sgml/catalog"
 #endif
 
 static int xmlExpandCatalog(xmlCatalogPtr catal, const char *filename);
