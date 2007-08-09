--- rpmio/rpmpgp.h.orig	2007-07-10 15:09:24.000000000 +0200
+++ rpmio/rpmpgp.h	2007-08-09 13:22:55.000000000 +0200
@@ -13,6 +13,8 @@
 #include <string.h>
 #include <popt.h>
 
+#include "beecrypt/api.h"
+
 #if !defined(_BEECRYPT_API_H)
 /*@-redef@*/
 typedef unsigned char byte;
