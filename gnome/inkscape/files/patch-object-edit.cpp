--- src/object-edit.cpp.sav	Fri Feb 25 18:38:30 2005
+++ src/object-edit.cpp	Fri Feb 25 18:39:01 2005
@@ -839,7 +839,7 @@
 			spiral->rad = rad_new;
 			spiral->t0 = pow (r0 / spiral->rad, 1/spiral->exp);
 		}
-		if (!std::isfinite(spiral->t0)) spiral->t0 = 0.0;
+		if (!__isfinite(spiral->t0)) spiral->t0 = 0.0;
 		spiral->t0 = CLAMP (spiral->t0, 0.0, 0.999);	
 	}
 
