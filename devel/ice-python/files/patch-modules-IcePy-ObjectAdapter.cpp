--- modules/IcePy/ObjectAdapter.cpp.orig	2007-02-01 08:53:05.000000000 -0800
+++ modules/IcePy/ObjectAdapter.cpp	2007-06-25 17:57:10.299784000 -0700
@@ -123,6 +123,7 @@
 
 IcePy::ServantWrapper::~ServantWrapper()
 {
+    AdoptThread adoptThread;
     Py_DECREF(_servant);
 }
 
