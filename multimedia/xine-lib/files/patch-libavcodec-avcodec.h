--- src/libffmpeg/libavcodec/avcodec.h.org	2005-06-22 13:39:47.000000000 +0200
+++ src/libffmpeg/libavcodec/avcodec.h	2005-06-22 13:41:00.000000000 +0200
@@ -1639,6 +1639,13 @@
 #define FF_OPT_MAX_DEPTH 10
 } AVOption;
 
+#ifdef HAVE_MMX
+extern const struct AVOption avoptions_common[3 + 5];
+#else
+extern const struct AVOption avoptions_common[3];
+#endif
+extern const struct AVOption avoptions_workaround_bug[11];
+
 /**
  * Parse option(s) and sets fields in passed structure
  * @param strct	structure where the parsed results will be written
