--- coders/png.c	2004-11-11 00:14:54.000000000 +0100
+++ coders/png.c	2006-06-20 09:13:04.000000000 +0200
@@ -1706,7 +1706,7 @@
      (int)sizeof(unused_chunks)/5);
 #endif
 
-#if defined(PNG_USE_PNGGCCRD) && defined(PNG_ASSEMBLER_CODE_SUPPORTED) \
+#if FALSE
 && (PNG_LIBPNG_VER >= 10200)
   /* Disable thread-unsafe features of pnggccrd */
   if (png_access_version() >= 10200)
