--- SSHTunnel.m.orig	2005-04-03 22:08:13.000000000 -0700
+++ SSHTunnel.m	2005-04-03 22:09:12.000000000 -0700
@@ -9,6 +9,7 @@
 
 #include <netdb.h>
 #include <unistd.h>
+#include <sys/param.h>
 #include "keychain.h"
 
 extern int		mfd;
