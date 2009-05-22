--- lqr/lqr_energy_priv.h.orig	2009-05-10 17:08:03.000000000 -0700
+++ lqr/lqr_energy_priv.h	2009-05-22 13:42:50.000000000 -0700
@@ -45,9 +45,9 @@
 inline gdouble lqr_carver_read_brightness_grey(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_brightness_std(LqrCarver *r, gint x, gint y);
 gdouble lqr_carver_read_brightness_custom(LqrCarver *r, gint x, gint y);
-inline gdouble lqr_carver_read_brightness(LqrCarver *r, gint x, gint y);
+gdouble lqr_carver_read_brightness(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_luma_std(LqrCarver *r, gint x, gint y);
-inline gdouble lqr_carver_read_luma(LqrCarver *r, gint x, gint y);
+gdouble lqr_carver_read_luma(LqrCarver *r, gint x, gint y);
 inline gdouble lqr_carver_read_rgba(LqrCarver *r, gint x, gint y, gint channel);
 inline gdouble lqr_carver_read_custom(LqrCarver *r, gint x, gint y, gint channel);
 
