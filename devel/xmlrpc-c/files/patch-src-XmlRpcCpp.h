--- src/XmlRpcCpp.h	Fri Dec 12 09:38:28 2003
+++ src/XmlRpcCpp.h	Fri Dec 12 09:38:34 2003
@@ -46,7 +46,7 @@
 // Tell me what your compiler does; I can provide some autoconf magic to the
 // Right Thing on most platforms.
 #include <string>
-// using namespace std;
+using namespace std;
 
 #include <xmlrpc.h>
 #include <xmlrpc_client.h>
