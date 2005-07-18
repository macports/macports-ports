--- ext/openssl/ossl_x509store.c	2004-12-19 09:28:32.000000000 +0100
+++ ext/openssl/ossl_x509store.c	2005-07-18 21:55:54.000000000 +0200
@@ -538,7 +538,7 @@
 
     if(NIL_P(time)) {
 	GetX509StCtx(self, store);
-	store->flags &= ~X509_V_FLAG_USE_CHECK_TIME;
+	store->param->flags &= ~X509_V_FLAG_USE_CHECK_TIME;
     }
     else {
 	long t = NUM2LONG(rb_Integer(time));
