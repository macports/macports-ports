--- parse.c.orig	Wed Jan 21 10:58:28 2004
+++ parse.c	Wed Jan 21 10:58:38 2004
@@ -848,7 +848,7 @@
 	tmpint[2]->cti_value = DEFAULT_VGAP;
 	tmpint[3] = ctlalloc1(CTL_QUALITY);
 	tmpint[3]->cti_value = DEFAULT_BQUALITY;
-#ifdef XFT2
+#ifdef USE_XFT2
 	tmpint[4] = ctlalloc1(CTL_OPAQUE);
 	tmpint[4]->cti_value = DEFAULT_OPAQUE;
 #endif
