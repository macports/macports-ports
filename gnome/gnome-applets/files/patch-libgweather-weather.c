--- libgweather/weather.c.original	2006-12-09 06:29:21.000000000 -0500
+++ libgweather/weather.c	2006-12-09 06:29:30.000000000 -0500
@@ -25,7 +25,7 @@
 #include <values.h>
 #endif
 
-#ifdef __FreeBSD__
+#ifdef __APPLE__
 #include <sys/types.h>
 #endif
 #include <regex.h>
