--- modules/bzip2-method.c.org	Sun Nov 23 17:22:25 2003
+++ modules/bzip2-method.c	Sun Nov 23 17:22:47 2003
@@ -37,13 +37,6 @@
 
 #include <bzlib.h>
 
-#ifdef HAVE_OLDER_BZIP2
-#define BZ2_bzDecompressInit  bzDecompressInit
-#define BZ2_bzCompressInit    bzCompressInit
-#define BZ2_bzDecompress      bzDecompress
-#define BZ2_bzCompress        bzCompress
-#endif
-
 #define BZ_BUFSIZE   5000
 
 struct _Bzip2MethodHandle {
