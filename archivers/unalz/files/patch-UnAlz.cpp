--- UnAlz.cpp.orig	2005-04-03 20:28:07.000000000 -0400
+++ UnAlz.cpp	2005-04-03 20:28:53.000000000 -0400
@@ -376,7 +376,7 @@
 	size_t size;
 	char inbuf[ICONV_BUF_SIZE];
 	char outbuf[ICONV_BUF_SIZE];
-#if defined(__FreeBSD__) || defined(__CYGWIN__)
+#if defined(__FreeBSD__) || defined(__CYGWIN__) || defined(__APPLE__)
 	const char *inptr = inbuf;
 #else
 	char *inptr = inbuf;
