--- ../tla/libneon.orig/ne_locks.c	Sat Dec  6 20:35:28 2003
+++ ../tla/libneon/ne_locks.c	Sat Apr 17 20:11:55 2004
@@ -734,7 +734,7 @@
 	}
 	else if (parse_failed) {
 	    ret = NE_ERROR;
-	    ne_set_error(sess, ne_xml_get_error(parser));
+	    ne_set_error(sess, "%s", ne_xml_get_error(parser));
 	}
 	else if (ne_get_status(req)->code == 207) {
 	    ret = NE_ERROR;
@@ -802,7 +802,7 @@
     if (ret == NE_OK && ne_get_status(req)->klass == 2) {
 	if (parse_failed) {
 	    ret = NE_ERROR;
-	    ne_set_error(sess, ne_xml_get_error(parser));
+	    ne_set_error(sess, "%s", ne_xml_get_error(parser));
 	}
 	else if (ne_get_status(req)->code == 207) {
 	    ret = NE_ERROR;
