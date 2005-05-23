--- Dependencies/zope.interface-ZopeInterface-3.0.1/zope.interface/_zope_interface_coptimizations.c	2004-08-04 12:03:17.000000000 +0200
+++ _zope_interface_coptimizations.c	2005-05-23 20:27:48.000000000 +0200
@@ -70,7 +70,7 @@
   return 0;
 }
 
-extern PyTypeObject SpecType;   /* Forward */
+static PyTypeObject SpecType;   /* Forward */
 
 static PyObject *
 implementedByFallback(PyObject *cls)
