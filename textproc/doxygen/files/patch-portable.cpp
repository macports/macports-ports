--- ./src/portable.cpp.orig	2007-07-17 11:38:43.000000000 +0200
+++ ./src/portable.cpp	2007-10-28 16:46:19.000000000 +0100
@@ -373,7 +373,7 @@ void * portable_iconv_open(const char* t
 size_t portable_iconv (void *cd, const char** inbuf,  size_t *inbytesleft, 
                                        char** outbuf, size_t *outbytesleft)
 {
-#if ((defined(_LIBICONV_VERSION) && (_LIBICONV_VERSION>=0x0109)) || defined(_OS_SOLARIS_))
+#if ((defined(_LIBICONV_VERSION) && (_LIBICONV_VERSION>=0x0109) && !defined(__APPLE__)) || defined(_OS_SOLARIS_))
 #define CASTNEEDED(x) (x)
 #else
 #define CASTNEEDED(x) (char **)(x)
