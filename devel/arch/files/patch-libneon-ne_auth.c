--- ../tla/libneon.orig/ne_auth.c	Sat Dec  6 20:35:28 2003
+++ ../tla/libneon/ne_auth.c	Sat Apr 17 20:11:55 2004
@@ -950,7 +950,7 @@
     if (areq->auth_info_hdr != NULL && 
 	verify_response(areq, sess, areq->auth_info_hdr)) {
 	NE_DEBUG(NE_DBG_HTTPAUTH, "Response authentication invalid.\n");
-	ne_set_error(sess->sess, _(sess->spec->fail_msg));
+	ne_set_error(sess->sess, "%s", _(sess->spec->fail_msg));
 	ret = NE_ERROR;
     } else if (status->code == sess->spec->status_code && 
 	       areq->auth_hdr != NULL) {
