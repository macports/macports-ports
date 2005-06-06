--- Pantomime/Framework/Pantomime/CWDNSManager.m	2004-11-27 22:20:56.000000000 +0100
+++ Pantomime/Framework/Pantomime/CWDNSManager.m	2005-06-06 14:55:54.000000000 +0200
@@ -24,6 +24,7 @@
 
 #include <Pantomime/CWConstants.h>
 #include <netdb.h>
+#include <string.h>
 
 static CWDNSManager *singleInstance = nil;
 
