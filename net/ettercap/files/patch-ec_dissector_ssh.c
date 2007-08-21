--- src/ec_dissector_ssh.c.orig	2003-07-10 10:25:32.000000000 +0200
+++ src/ec_dissector_ssh.c	2007-08-21 13:10:26.000000000 +0200
@@ -39,6 +39,7 @@
 
 #include <openssl/ssl.h>
 #include <openssl/rand.h>
+#include <openssl/des.h>
 #include <ctype.h>
 
 #include "include/ec_dissector.h"
