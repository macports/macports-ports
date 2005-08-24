--- plugins/plot_radar/gog-radar.c.org	2005-08-22 15:17:21.000000000 +0200
+++ plugins/plot_radar/gog-radar.c	2005-08-22 15:17:52.000000000 +0200
@@ -386,7 +386,7 @@
 typedef GogPlotView		GogRTView;
 typedef GogPlotViewClass	GogRTViewClass;
 
-static double
+double
 fmin (double a, double b)
 {
 	return (a < b) ? a : b;
