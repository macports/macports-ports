--- src/object-edit.cpp.orig Sun Jan 30 21:40:52 2005
+++ src/object-edit.cpp Sat Apr 9 18:35:02 2005
@@ -839,7 +839,7 @@
spiral->rad = rad_new;
spiral->t0 = pow (r0 / spiral->rad, 1/spiral->exp);
}
- if (!std::isfinite(spiral->t0)) spiral->t0 = 0.0;
+ if (isinf(spiral->t0)) spiral->t0 = 0.0;
spiral->t0 = CLAMP (spiral->t0, 0.0, 0.999); 
}
