--- etc/uams/uams_randnum.c~	2009-03-29 09:23:23.000000000 +0200
+++ etc/uams/uams_randnum.c	2009-11-14 16:33:14.000000000 +0100
@@ -50,7 +50,7 @@
 #include <des.h>
 
 #ifdef USE_CRACKLIB
-#include <crack.h>
+#include <packer.h>
 #endif /* USE_CRACKLIB */
 
 #define PASSWDLEN 8
