--- src/libffmpeg/libavcodec/common.h.org	2005-06-22 13:41:17.000000000 +0200
+++ src/libffmpeg/libavcodec/common.h	2005-06-22 13:41:51.000000000 +0200
@@ -66,14 +66,6 @@
 #define AVOPTION_SUB(ptr) { .name = NULL, .help = (const char*)ptr }
 #define AVOPTION_END() AVOPTION_SUB(NULL)
 
-struct AVOption;
-#ifdef HAVE_MMX
-extern const struct AVOption avoptions_common[3 + 5];
-#else
-extern const struct AVOption avoptions_common[3];
-#endif
-extern const struct AVOption avoptions_workaround_bug[11];
-
 #endif /* HAVE_AV_CONFIG_H */
 
 /* Suppress restrict if it was not defined in config.h.  */
