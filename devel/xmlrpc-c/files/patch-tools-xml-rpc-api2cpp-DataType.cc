--- tools/xml-rpc-api2cpp/DataType.cc	Fri Dec 12 10:10:26 2003
+++ tools/xml-rpc-api2cpp/DataType.cc	Fri Dec 12 10:10:52 2003
@@ -1,5 +1,5 @@
 #include <iostream.h>
-#include <strstream.h>
+#include <sstream>
 #include <stdexcept>
 
 #include <XmlRpcCpp.h>
@@ -13,11 +13,9 @@
 //  a specific XML-RPC data type.
 
 string DataType::defaultParameterBaseName (int position) const {
-    ostrstream name_stream;
+    std::ostringstream name_stream;
     name_stream << typeName() << position << ends;
     string name(name_stream.str());
-    // (Ask the ostrstream to reclaim ownership of its buffer.)
-    name_stream.freeze(false);
     return name;
 }
 
