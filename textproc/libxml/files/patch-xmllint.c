diff -Naur xmllint.c xmllint.c
--- xmllint.c	Sun Jun 16 11:35:21 2002
+++ xmllint.c	Sun Jul 14 16:11:10 2002
@@ -1024,7 +1024,7 @@
 #ifdef LIBXML_CATALOG_ENABLED
     printf("\t--catalogs : use SGML catalogs from $SGML_CATALOG_FILES\n");
     printf("\t             otherwise XML Catalogs starting from \n");
-    printf("\t         file:///etc/xml/catalog are activated by default\n");
+    printf("\t         file://@PREFIX@/etc/xml/catalog are activated by default\n");
     printf("\t--nocatalogs: deactivate all catalogs\n");
 #endif
     printf("\t--auto : generate a small doc on the fly\n");
