--- gweather/weather.c.org	2005-03-14 22:17:57.000000000 +0100
+++ gweather/weather.c	2005-03-15 06:37:39.000000000 +0100
@@ -20,9 +20,9 @@
 #include <string.h>
 #include <ctype.h>
 #include <math.h>
-#include <values.h>
+/* #include <values.h> */
 
-#ifdef __FreeBSD__
+#ifdef __APPLE__
 #include <sys/types.h>
 #endif
 #include <regex.h>
