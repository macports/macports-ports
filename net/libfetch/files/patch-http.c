--- libfetch/http.c.orig	Tue Aug 20 19:47:22 2002
+++ libfetch/http.c	Tue Aug 20 19:47:43 2002
@@ -80,8 +80,6 @@
 #include "common.h"
 #include "httperr.h"
 
-extern char *__progname; /* XXX not portable */
-
 /* Maximum number of redirects to follow */
 #define MAX_REDIRECT 5
 
@@ -834,7 +832,7 @@
 	if ((p = getenv("HTTP_USER_AGENT")) != NULL && *p != '\0')
 	    _http_cmd(fd, "User-Agent: %s", p);
 	else
-	    _http_cmd(fd, "User-Agent: %s " _LIBFETCH_VER, __progname);
+	    _http_cmd(fd, "User-Agent: %s " _LIBFETCH_VER, "libfetch");
 	if (url->offset)
 	    _http_cmd(fd, "Range: bytes=%lld-", (long long)url->offset);
 	_http_cmd(fd, "Connection: close");
