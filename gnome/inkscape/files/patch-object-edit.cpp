--- src/object-edit.cpp.orig	2007-02-27 13:21:54.000000000 -0500
+++ src/object-edit.cpp	2007-02-27 14:41:08.000000000 -0500
@@ -918,7 +918,7 @@
             spiral->rad = rad_new;
             spiral->t0 = pow(r0 / spiral->rad, 1.0/spiral->exp);
         }
-        if (!isFinite(spiral->t0)) spiral->t0 = 0.0;
+        if (isinf(spiral->t0)) spiral->t0 = 0.0;
         spiral->t0 = CLAMP(spiral->t0, 0.0, 0.999);
     }
 
