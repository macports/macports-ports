--- tls.c.orig	2006-11-25 18:52:08.000000000 +0000
+++ tls.c	2019-03-22 17:37:16.971621000 +0000
@@ -73,10 +73,12 @@
 		printf("egd_sock is %s\n", egd_sock);
 #ifdef HAVE_RAND_STATUS
 	if (RAND_status() != 1) {
+#ifdef HAVE_RAND_EGD
 		if ( RAND_egd(egd_sock) == -1 ) {
 			fprintf(stderr, "egd_sock is %s\n", egd_sock);
 			sys_err("RAND_egd failed\n");
 		}
+#endif
 		if (RAND_status() != 1)
 			sys_err("ssl_init: System without /dev/urandom, PRNG seeding must be done manually.\r\n");
 	}
@@ -258,7 +260,7 @@
 	X509 				*x509_peer;
 	X509_NAME			*x509_subj;
 	X509_EXTENSION 		*x509_ext;
-	X509V3_EXT_METHOD	*x509_meth;
+	const X509V3_EXT_METHOD	*x509_meth;
 	int					ok, extcount, i, j;
 	char 				*extstr;
 	SSL					*ssl;
@@ -294,15 +296,17 @@
 			extstr = (char*)OBJ_nid2sn(OBJ_obj2nid(X509_EXTENSION_get_object(x509_ext)));
 			if (debug) printf("extstr = %s\n", extstr);
 			if (!strcmp(extstr, "subjectAltName")) {
+				ASN1_OCTET_STRING *x509_ext_data;
 				subjectaltname = 1;
 				if	(!(x509_meth = X509V3_EXT_get(x509_ext)))
 					break;
-				data1 = x509_ext->value->data;
+				x509_ext_data = X509_EXTENSION_get_data(x509_ext);
+				data1 = x509_ext_data->data;
 #if (OPENSSL_VERSION_NUMBER > 0x00907000L)     
 				if (x509_meth->it)
-					ext_str = ASN1_item_d2i(NULL, &data1, x509_ext->value->length, ASN1_ITEM_ptr(x509_meth->it));
+					ext_str = ASN1_item_d2i(NULL, &data1, x509_ext_data->length, ASN1_ITEM_ptr(x509_meth->it));
 				else
-					ext_str = x509_meth->d2i(NULL, &data1, x509_ext->value->length);
+					ext_str = x509_meth->d2i(NULL, &data1, x509_ext_data->length);
 #else
 				ext_str = x509_meth->d2i(NULL, &data1, x509_ext->value->length);
 #endif
@@ -341,7 +345,7 @@
 tls_auth_cont(struct user_data *ud, int data)
 {
 	int status, sslerr, cert_ok;
-	SSL_CIPHER *cipher;
+	const SSL_CIPHER *cipher;
 	char cipher_info[128];
 	SSL *ssl;
 
