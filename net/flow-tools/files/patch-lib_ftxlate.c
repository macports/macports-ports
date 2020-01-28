--- lib/ftxlate.c.orig	2005-05-12 00:03:30.000000000 +1000
+++ lib/ftxlate.c	2020-01-28 12:50:16.000000000 +1100
@@ -2033,7 +2033,7 @@ static int cryptopan_init(struct cryptop
 
 
   /* init crypto */
-  if (!(cp->cipher_ctx = (EVP_CIPHER_CTX*) malloc(sizeof(EVP_CIPHER_CTX)))) {
+  if (!(cp->cipher_ctx = EVP_CIPHER_CTX_new())) {
     return -1;
   }
 
