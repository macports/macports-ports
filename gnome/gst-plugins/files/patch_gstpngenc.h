--- ext/libpng/gstpngenc.h.org	Fri Jan 23 15:44:03 2004
+++ ext/libpng/gstpngenc.h	Fri Jan 23 15:44:28 2004
@@ -38,7 +38,7 @@
 typedef struct _GstPngEnc GstPngEnc;
 typedef struct _GstPngEncClass GstPngEncClass;
 
-GstPadTemplate *pngenc_src_template, *pngenc_sink_template;
+extern GstPadTemplate *pngenc_src_template, *pngenc_sink_template;
 
 struct _GstPngEnc
 {
