--- examples/meerkat-app-list.cc.old	Fri Dec 12 10:07:04 2003
+++ examples/meerkat-app-list.cc	Fri Dec 12 10:09:17 2003
@@ -3,7 +3,9 @@
 // http://www.oreillynet.com/pub/a/rss/2000/11/14/meerkat_xmlrpc.html */
 
 #include <iostream.h>
-#include <strstream.h>
+#include <sstream>
+
+using namespace std;
 
 #include <XmlRpcCpp.h>
 
@@ -17,12 +15,9 @@
 static void list_apps (int hours) {
 
     // Build our time_period parameter.
-    ostrstream time_period_stream;
+    std::ostringstream time_period_stream;
     time_period_stream << hours << "HOUR" << ends;
     string time_period = time_period_stream.str();
-
-    // (Ask the ostrstream to reclaim ownership of its buffer.)
-    time_period_stream.freeze(false);
 
     // Assemble our meerkat query recipe.
     XmlRpcValue recipe = XmlRpcValue::makeStruct();
