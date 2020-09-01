--- src/lftp_ssl.cc.orig	2020-01-29 20:36:37 UTC
+++ src/lftp_ssl.cc
@@ -34,7 +34,7 @@
 #include "misc.h"
 #include "network.h"
 #include "buffer.h"
-#if OPENSSL_VERSION_NUMBER < 0x10100000L
+#if OPENSSL_VERSION_NUMBER < 0x10100000L || LIBRESSL_VERSION_NUMBER
 #define X509_STORE_CTX_get_by_subject X509_STORE_get_by_subject
 #endif
 extern "C" {
@@ -840,7 +840,7 @@ lftp_ssl_openssl_instance::lftp_ssl_openssl_instance()
    ssl_ctx=SSL_CTX_new();
    X509_set_default_verify_paths(ssl_ctx->cert);
 #else
-#if OPENSSL_VERSION_NUMBER < 0x10100000L
+#if OPENSSL_VERSION_NUMBER < 0x10100000L || LIBRESSL_VERSION_NUMBER
    SSLeay_add_ssl_algorithms();
 #endif
    ssl_ctx=SSL_CTX_new(SSLv23_client_method());
@@ -1080,7 +1080,7 @@ void lftp_ssl_openssl::copy_sid(const lftp_ssl_openssl
 
 const char *lftp_ssl_openssl::strerror()
 {
-#if OPENSSL_VERSION_NUMBER < 0x10100000L
+#if OPENSSL_VERSION_NUMBER < 0x10100000L || LIBRESSL_VERSION_NUMBER
    SSL_load_error_strings();
 #endif
    int error=ERR_get_error();
