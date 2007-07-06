--- http.h.orig	2007-07-03 02:08:49.000000000 -0700
+++ http.h	2007-07-03 02:09:00.000000000 -0700
@@ -7,7 +7,6 @@
 #include <curl/easy.h>
 
 #if LIBCURL_VERSION_NUM >= 0x071000
-#define USE_CURL_MULTI
 #define DEFAULT_MAX_REQUESTS 5
 #endif
 
