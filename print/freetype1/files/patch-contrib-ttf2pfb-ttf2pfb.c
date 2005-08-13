--- contrib/ttf2pfb/ttf2pfb.orig	2005-08-13 15:39:37.000000000 +0900
+++ contrib/ttf2pfb/ttf2pfb.c	2005-08-13 15:55:19.000000000 +0900
@@ -364,7 +364,7 @@
   int       i, j;
 
   va_start(vp, dummy);
-  numCR = va_arg(vp, UShort);
+  numCR = va_arg(vp, int);
 
   encVec = re_alloc(encVec, 1 * sizeof (EncVec), "Alloc_EncVec");
   encVec->numCodeRanges = numCR;
@@ -372,15 +372,15 @@
   cRange = re_alloc(cRange, numCR * sizeof (EVcRange), "Alloc_EncVec");
   for (i = 0; i < numCR; i++)
   {
-    (cRange + i)->high.start   = va_arg(vp, UShort);
-    (cRange + i)->high.end     = va_arg(vp, UShort);
-    (cRange + i)->numLowRanges = numLows = va_arg(vp, UShort);
+    (cRange + i)->high.start   = va_arg(vp, int);
+    (cRange + i)->high.end     = va_arg(vp, int);
+    (cRange + i)->numLowRanges = numLows = va_arg(vp, int);
     evLow = NULL;
     evLow = re_alloc(evLow, numLows * sizeof (EVLow), "Alloc_EncVec");
     for (j = 0; j < numLows; j++)
     {
-      (evLow + j)->start = va_arg(vp, UChar);
-      (evLow + j)->end   = va_arg(vp, UChar);
+      (evLow + j)->start = va_arg(vp, int);
+      (evLow + j)->end   = va_arg(vp, int);
     }
     (cRange + i)->low = evLow;
   }
