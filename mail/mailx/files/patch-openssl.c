--- openssl.c	2007/08/04 11:41:36	1.12
+++ openssl.c	2009/05/26 21:04:15	1.13
@@ -101,12 +101,17 @@
 static int ssl_rand_init(void);
 static void ssl_init(void);
 static int ssl_verify_cb(int success, X509_STORE_CTX *store);
-static SSL_METHOD *ssl_select_method(const char *uhp);
+static const SSL_METHOD *ssl_select_method(const char *uhp);
 static void ssl_load_verifications(struct sock *sp);
 static void ssl_certificate(struct sock *sp, const char *uhp);
 static enum okay ssl_check_host(const char *server, struct sock *sp);
+#ifdef HAVE_STACK_OF
+static int smime_verify(struct message *m, int n, STACK_OF(X509) *chain,
+		X509_STORE *store);
+#else
 static int smime_verify(struct message *m, int n, STACK *chain,
 		X509_STORE *store);
+#endif
 static EVP_CIPHER *smime_cipher(const char *name);
 static int ssl_password_cb(char *buf, int size, int rwflag, void *userdata);
 static FILE *smime_sign_cert(const char *xname, const char *xname2, int warn);
@@ -203,10 +208,10 @@
 	return 1;
 }
 
-static SSL_METHOD *
+static const SSL_METHOD *
 ssl_select_method(const char *uhp)
 {
-	SSL_METHOD *method;
+	const SSL_METHOD *method;
 	char	*cp;
 
 	cp = ssl_method_string(uhp);
@@ -308,7 +313,11 @@
 	X509 *cert;
 	X509_NAME *subj;
 	char data[256];
+#ifdef HAVE_STACK_OF
+	STACK_OF(GENERAL_NAME)	*gens;
+#else
 	/*GENERAL_NAMES*/STACK	*gens;
+#endif
 	GENERAL_NAME	*gen;
 	int	i;
 
@@ -357,7 +366,8 @@
 
 	ssl_init();
 	ssl_set_vrfy_level(uhp);
-	if ((sp->s_ctx = SSL_CTX_new(ssl_select_method(uhp))) == NULL) {
+	if ((sp->s_ctx =
+	     SSL_CTX_new((SSL_METHOD *)ssl_select_method(uhp))) == NULL) {
 		ssl_gen_err(catgets(catd, CATSET, 261, "SSL_CTX_new() failed"));
 		return STOP;
 	}
@@ -496,7 +506,11 @@
 }
 
 static int
+#ifdef HAVE_STACK_OF
+smime_verify(struct message *m, int n, STACK_OF(X509) *chain, X509_STORE *store)
+#else
 smime_verify(struct message *m, int n, STACK *chain, X509_STORE *store)
+#endif
 {
 	struct message	*x;
 	char	*cp, *sender, *to, *cc, *cnttype;
@@ -505,7 +519,12 @@
 	off_t	size;
 	BIO	*fb, *pb;
 	PKCS7	*pkcs7;
+#ifdef HAVE_STACK_OF
+	STACK_OF(X509)	*certs;
+	STACK_OF(GENERAL_NAME)	*gens;
+#else
 	STACK	*certs, *gens;
+#endif
 	X509	*cert;
 	X509_NAME	*subj;
 	char	data[LINESIZE];
@@ -614,7 +633,11 @@
 {
 	int	*msgvec = vp, *ip;
 	int	ec = 0;
+#ifdef HAVE_STACK_OF
+	STACK_OF(X509)	*chain = NULL;
+#else
 	STACK	*chain = NULL;
+#endif
 	X509_STORE	*store;
 	char	*ca_dir, *ca_file;
 
@@ -687,7 +710,11 @@
 	X509	*cert;
 	PKCS7	*pkcs7;
 	BIO	*bb, *yb;
+#ifdef HAVE_STACK_OF
+	STACK_OF(X509)	*certs;
+#else
 	STACK	*certs;
+#endif
 	EVP_CIPHER	*cipher;
 
 	certfile = expand((char *)certfile);
@@ -950,9 +977,14 @@
 	off_t	size;
 	BIO	*fb, *pb;
 	PKCS7	*pkcs7;
+#ifdef HAVE_STACK_OF
+	STACK_OF(X509)	*certs;
+	STACK_OF(X509)	*chain = NULL;
+#else
 	STACK	*certs;
-	X509	*cert;
 	STACK	*chain = NULL;
+#endif
+	X509	*cert;
 	enum okay	ok = OKAY;
 
 	message_number = n;
