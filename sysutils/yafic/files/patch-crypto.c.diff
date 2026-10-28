--- crypto.c.orig	2004-03-21 04:02:32.000000000 -0800
+++ crypto.c	2018-10-15 15:18:25.842905000 -0700
@@ -56,6 +56,30 @@
 
 static EVP_PKEY *pkey;
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
+
+static void *OPENSSL_zalloc (size_t num)
+{
+  void *ret = OPENSSL_malloc (num);
+
+  if (ret != NULL)
+    memset (ret, 0, num);
+  return ret;
+}
+
+EVP_MD_CTX *EVP_MD_CTX_new (void)
+{
+  return OPENSSL_zalloc (sizeof (EVP_MD_CTX));
+}
+
+void EVP_MD_CTX_free (EVP_MD_CTX *ctx)
+{
+  EVP_MD_CTX_cleanup (ctx);
+  OPENSSL_free (ctx);
+}
+
+#endif /* OPENSSL_VERSION_NUMBER < 0x10100000L */
+
 static void
 opensslError (const char *what)
 {
@@ -100,7 +124,7 @@
 SignFile (int fd, const char *filename, const char *sigfile)
 {
   const EVP_MD *mdType;
-  EVP_MD_CTX ctx;
+  EVP_MD_CTX *ctx;
   ssize_t len;
   unsigned char *sig = NULL;
   unsigned int sigLen;
@@ -111,8 +135,12 @@
   if (!pkey)
     return;
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
   mdType = EVP_PKEY_type (pkey->type) == EVP_PKEY_DSA ? EVP_dss1 () :
     EVP_sha1 ();
+#else
+  mdType = EVP_sha1 ();
+#endif
 
   if (!sigfile) {
     int tlen = strlen (filename) + 4 + 1;
@@ -122,21 +150,23 @@
     sigfile = tsigfile;
   }
 
+  if ((ctx = EVP_MD_CTX_new ()) == NULL)
+    opensslError ("EVP_MD_CTX_new");
 #ifdef HAVE_EVP_MD_CTX_INIT
-  EVP_MD_CTX_init (&ctx);
+  EVP_MD_CTX_init (ctx);
 #endif
 #ifdef EVP_DIGESTINIT_VOID
-  EVP_SignInit (&ctx, mdType);
+  EVP_SignInit (ctx, mdType);
 #else
-  if (!EVP_SignInit (&ctx, mdType))
+  if (!EVP_SignInit (ctx, mdType))
     opensslError ("EVP_SignInit");
 #endif
 
   while ((len = read (fd, HashBuffer, HASH_BUFFER_SIZE)) > 0) {
 #ifdef EVP_DIGESTINIT_VOID
-    EVP_SignUpdate (&ctx, HashBuffer, len);
+    EVP_SignUpdate (ctx, HashBuffer, len);
 #else
-    if (!EVP_SignUpdate (&ctx, HashBuffer, len))
+    if (!EVP_SignUpdate (ctx, HashBuffer, len))
       opensslError ("EVP_SignUpdate");
 #endif
   }
@@ -146,7 +176,7 @@
 
   sig = mymalloc (EVP_PKEY_size (pkey));
 
-  if (EVP_SignFinal (&ctx, sig, &sigLen, pkey)) {
+  if (EVP_SignFinal (ctx, sig, &sigLen, pkey)) {
     if ((f = open (sigfile, O_CREAT|O_WRONLY|O_TRUNC, 0600)) != -1) {
       if (write (f, sig, sigLen) != sigLen)
 	yaficError (sigfile);
@@ -162,15 +192,16 @@
   if (sig) free (sig);
   if (tsigfile) free (tsigfile);
 #ifdef HAVE_EVP_MD_CTX_CLEANUP
-  EVP_MD_CTX_cleanup (&ctx);
+  EVP_MD_CTX_cleanup (ctx);
 #endif
+  EVP_MD_CTX_free (ctx);
 }
 
 void
 VerifyFile (int fd, const char *filename, const char *sigfile)
 {
   const EVP_MD *mdType;
-  EVP_MD_CTX ctx;
+  EVP_MD_CTX *ctx;
   ssize_t len;
   unsigned char *sig = NULL;
   int f;
@@ -181,8 +212,12 @@
   if (!pkey)
     return;
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
   mdType = EVP_PKEY_type (pkey->type) == EVP_PKEY_DSA ? EVP_dss1 () :
     EVP_sha1 ();
+#else
+  mdType = EVP_sha1 ();
+#endif
 
   if (!sigfile) {
     int tlen = strlen (filename) + 4 + 1;
@@ -195,13 +230,15 @@
   fprintf (stderr, "Verifying %s: ", filename);
   fflush (stderr);
 
+  if ((ctx = EVP_MD_CTX_new ()) == NULL)
+    opensslError ("EVP_MD_CTX_new");
 #ifdef HAVE_EVP_MD_CTX_INIT
-  EVP_MD_CTX_init (&ctx);
+  EVP_MD_CTX_init (ctx);
 #endif
 #ifdef EVP_DIGESTINIT_VOID
-  EVP_VerifyInit (&ctx, mdType);
+  EVP_VerifyInit (ctx, mdType);
 #else
-  if (!EVP_VerifyInit (&ctx, mdType)) {
+  if (!EVP_VerifyInit (ctx, mdType)) {
     fprintf (stderr, "Error\n");
     opensslError ("EVP_VerifyInit");
   }
@@ -209,9 +246,9 @@
 
   while ((len = read (fd, HashBuffer, HASH_BUFFER_SIZE)) > 0) {
 #ifdef EVP_DIGESTINIT_VOID
-    EVP_VerifyUpdate (&ctx, HashBuffer, len);
+    EVP_VerifyUpdate (ctx, HashBuffer, len);
 #else
-    if (!EVP_VerifyUpdate (&ctx, HashBuffer, len)) {
+    if (!EVP_VerifyUpdate (ctx, HashBuffer, len)) {
       fprintf (stderr, "Error\n");
       opensslError ("EVP_SignUpdate");
     }
@@ -233,7 +270,7 @@
 
     close (f);
 
-    ret = EVP_VerifyFinal (&ctx, sig, len, pkey);
+    ret = EVP_VerifyFinal (ctx, sig, len, pkey);
     if (ret < 0) {
       fprintf (stderr, "Error\n");
       opensslError ("EVP_VerifyFinal");
@@ -254,8 +291,9 @@
   if (sig) free (sig);
   if (tsigfile) free (tsigfile);
 #ifdef HAVE_EVP_MD_CTX_CLEANUP
-  EVP_MD_CTX_cleanup (&ctx);
+  EVP_MD_CTX_cleanup (ctx);
 #endif
+  EVP_MD_CTX_free (ctx);
 }
 
 const char *
@@ -265,7 +303,11 @@
 
   if (pkey) {
     int bits = EVP_PKEY_bits (pkey);
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     int type = EVP_PKEY_type (pkey->type);
+#else
+    int type = EVP_PKEY_base_id (pkey);
+#endif
 
     switch (type) {
     case EVP_PKEY_RSA:
