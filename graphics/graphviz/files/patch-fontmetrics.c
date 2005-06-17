--- dotneato/common/fontmetrics.c.org	Sat Dec 11 22:26:00 2004
+++ dotneato/common/fontmetrics.c	Fri Apr  1 23:29:33 2005
@@ -212,6 +212,12 @@
     textline->xshow = NULL;
     fontpath = "[cairo]";
 #else
+#ifdef QUARTZ_RENDER
+    if (Output_lang == QPDF || Output_lang == QEPDF ||
+	    (Output_lang >= QBM_FIRST && Output_lang <= QBM_LAST))
+	quartz_textsize(textline, fontname, fontsize, &fontpath);
+    else
+#endif
     if (gd_textsize(textline, fontname, fontsize, &fontpath))
 	estimate_textsize(textline, fontname, fontsize, &fontpath);
 #endif
