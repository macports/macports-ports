diff -urN ../ijb-zlib-11.orig/parsers.c ./parsers.c
--- ../ijb-zlib-11.orig/parsers.c	Thu Aug  3 23:39:19 2000
+++ ./parsers.c	Thu Jan  6 15:39:42 2005
@@ -19,7 +19,7 @@
 #endif
 
 #ifdef REGEX
-#include <gnu_regex.h>
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
@@ -32,6 +32,7 @@
 	{ "cookie:",		 7,	client_send_cookie	},
 	{ "x-forwarded-for:",	16,	client_x_forwarded	},
 	{ "proxy-connection:",	17,	crumble			},
+	{ "keep-alive:",	11,	crumble			},
 /*	{ "if-modified-since:", 18,	crumble			}, */
 	{ NULL,			 0,	NULL			}
 };
@@ -57,6 +58,7 @@
 };
 
 void (*add_server_headers[])() = {
+	server_conn_close_adder,	/* for http/1.1 */
 	NULL
 };
 
@@ -608,6 +610,12 @@
 	if(csp->accept_server_cookie == 0) return(crumble(v, s, csp));
 
 	return(strdup(s));
+}
+
+void server_conn_close_adder(struct client_state *csp)
+{
+	char *p = strsav(NULL, "Connection: close");
+	enlist(csp->headers, p);
 }
 
 /* case insensitive string comparison */
