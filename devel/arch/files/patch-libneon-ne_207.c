--- ../tla/libneon.orig/ne_207.c	Sat Dec  6 20:35:28 2003
+++ ../tla/libneon/ne_207.c	Sat Apr 17 20:25:46 2004
@@ -320,12 +320,12 @@
 	if (ne_get_status(req)->code == 207) {
 	    if (!ne_xml_valid(p)) { 
 		/* The parse was invalid */
-		ne_set_error(sess, ne_xml_get_error(p));
-		ret = NE_ERROR;
+		ne_set_error(sess, "%s", ne_xml_get_error(p));
+			ret = NE_ERROR;
 	    } else if (ctx.is_error) {
 		/* If we've actually got any error information
 		 * from the 207, then set that as the error */
-		ne_set_error(sess, ctx.buf->data);
+                ne_set_error(sess, "%s", ctx.buf->data);
 		ret = NE_ERROR;
 	    }
 	} else if (ne_get_status(req)->klass != 2) {
