--- ../tla/libneon.orig/ne_props.c	Sat Dec  6 20:35:28 2003
+++ ../tla/libneon/ne_props.c	Sat Apr 17 20:11:55 2004
@@ -142,7 +142,7 @@
     if (ret == NE_OK && ne_get_status(req)->klass != 2) {
 	ret = NE_ERROR;
     } else if (!ne_xml_valid(handler->parser)) {
-	ne_set_error(handler->sess, ne_xml_get_error(handler->parser));
+	ne_set_error(handler->sess, "%s", ne_xml_get_error(handler->parser));
 	ret = NE_ERROR;
     }
 
