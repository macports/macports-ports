--- modules/ssl/ssl_toolkit_compat.h	2005-07-10 14:11:32.000000000 +0200
+++ modules/ssl/ssl_toolkit_compat.h	2005-07-10 14:11:59.000000000 +0200
@@ -99,6 +99,13 @@
 #define HAVE_SSL_X509V3_EXT_d2i
 #endif
 
+#ifndef PEM_F_DEF_CALLBACK
+#ifdef PEM_F_PEM_DEF_CALLBACK
+/* In OpenSSL 0.9.8 PEM_F_DEF_CALLBACK was renamed */
+#define PEM_F_DEF_CALLBACK PEM_F_PEM_DEF_CALLBACK
+#endif
+#endif
+
 #elif defined (SSLC_VERSION_NUMBER) /* RSA */
 
 /* sslc does not support this function, OpenSSL has since 9.5.1 */
