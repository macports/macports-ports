--- ../tla/libneon.orig/ne_xml.c	Sat Dec  6 20:35:29 2003
+++ ../tla/libneon/ne_xml.c	Sat Apr 17 20:11:55 2004
@@ -538,7 +538,7 @@
 
 void ne_xml_set_error(ne_xml_parser *p, const char *msg)
 {
-    ne_snprintf(p->error, ERR_SIZE, msg);
+    ne_snprintf(p->error, ERR_SIZE, "%s", msg);
 }
 
 #ifdef HAVE_LIBXML
