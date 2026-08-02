diff -urN ../ijb-zlib-11.orig/socks4.c ./socks4.c
--- ../ijb-zlib-11.orig/socks4.c	Thu Aug  3 23:39:21 2000
+++ ./socks4.c	Thu Jan  6 15:39:42 2005
@@ -11,6 +11,7 @@
 
 
 #include <stdio.h>
+#include <string.h>
 #include <sys/types.h>
 #include <errno.h>
 
@@ -23,11 +24,13 @@
 #endif
 
 #ifdef REGEX
-#include <gnu_regex.h>
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
 
+#define DEFAULT_FALLBACK_HTTP_PORT	80
+
 #define SOCKS_REQUEST_GRANTED		90
 #define SOCKS_REQUEST_REJECT		91
 #define SOCKS_REQUEST_IDENT_FAILED	92
@@ -60,7 +63,7 @@
 	unsigned char sbuf[BUFSIZ];
 	struct socks_op    *c = (struct socks_op    *)cbuf;
 	struct socks_reply *s = (struct socks_reply *)sbuf;
-	int web_server_addr;
+	int web_server_addr = DEFAULT_FALLBACK_HTTP_PORT;
 	int n, csiz, sfd, target_port;
 	int err = 0;
 	char *errstr, *target_host;
@@ -110,6 +113,8 @@
 		strcpy(((char *)cbuf) + csiz, http->host);
 		csiz = n;
 		break;
+	default:
+		return -1; /* oops */
 	}
 
 	c->vn         = 4;
