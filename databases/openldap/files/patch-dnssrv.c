--- libraries/libldap/dnssrv.c.orig	Fri Jan  2 01:47:34 2004
+++ libraries/libldap/dnssrv.c	Fri Jan  2 01:48:08 2004
@@ -28,6 +28,8 @@
 #include <resolv.h>
 #endif
 
+#include <nameser8_compat.h>
+
 /* Sometimes this is not defined. */
 #ifndef T_SRV
 #define T_SRV            33
