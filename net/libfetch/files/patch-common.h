--- common.h.orig	2004-09-21 20:35:20.000000000 +0200
+++ common.h	2007-09-08 22:33:03.000000000 +0200
@@ -31,6 +31,11 @@
 #ifndef _COMMON_H_INCLUDED
 #define _COMMON_H_INCLUDED
 
+/* from <sys/cdefs.h> */
+#ifndef	__DECONST
+#define	__DECONST(type, var)	((type)(uintptr_t)(const void *)(var))
+#endif
+
 #define FTP_DEFAULT_PORT	21
 #define HTTP_DEFAULT_PORT	80
 #define FTP_DEFAULT_PROXY_PORT	21
