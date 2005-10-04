--- hydra-sip.c	2005-09-07 22:17:56.000000000 +0200
+++ hydra-sip.c	2005-10-04 14:42:20.000000000 +0200
@@ -3,6 +3,7 @@
 
 #include <openssl/ssl.h>
 #include <openssl/err.h>
+#include <openssl/md5.h>
 
 #include "hydra-mod.h"
 
