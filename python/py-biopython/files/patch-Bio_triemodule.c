--- Bio/triemodule.c	Thu Apr 24 21:06:23 2003
+++ Bio/triemodule.c.new	Tue Dec 28 12:45:47 2004
@@ -477,8 +477,14 @@
     int length;
     int success = 0;
 
-    if(!(py_marshalled = PyMarshal_WriteObjectToString(py_value)))
-	goto _write_value_to_handle_cleanup;
+#ifdef Py_MARSHAL_VERSION  
+    if(!(py_marshalled =   
+	 PyMarshal_WriteObjectToString(py_value, Py_MARSHAL_VERSION)))  
+        goto _write_value_to_handle_cleanup;  
+#else  
+    if(!(py_marshalled = PyMarshal_WriteObjectToString(py_value)))  
+        goto _write_value_to_handle_cleanup;  
+#endif  
     if(PyString_AsStringAndSize(py_marshalled, &marshalled, &length) == -1)
 	goto _write_value_to_handle_cleanup;
     if(!_write_to_handle(&length, sizeof(length), handle))
