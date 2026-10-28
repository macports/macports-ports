--- http.c.orig	2010-02-10 01:26:20.000000000 +0100
+++ http.c	2010-10-14 09:37:39.000000000 +0200
@@ -76,7 +76,14 @@
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
+#ifndef WITH_SSL_MD5
 #include <md5.h>
+#else
+#include <openssl/md5.h>
+#define MD5Init(c) MD5_Init(c)
+#define MD5Update(c,data,len) MD5_Update(c,data,(unsigned)len)
+#define MD5Final(d,c) MD5_Final((unsigned char *)d,c)
+#endif
 
 #include <netinet/in.h>
 #include <netinet/tcp.h>
