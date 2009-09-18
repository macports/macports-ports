diff -u pyliblzma-0.5.2.orig/liblzma.h pyliblzma-0.5.2/liblzma.h
--- liblzma.h	2009-01-26 01:51:17.000000000 +0100
+++ liblzma.h	2009-03-02 10:29:20.000000000 +0100
@@ -49,5 +58,5 @@
 
 #define INITCHECK if (!self->is_initialised) {	PyErr_Format(PyExc_RuntimeError, "%s object not initialised!", self->ob_type->tp_name);	return NULL; }
 
-PyObject *module;
+extern PyObject *module;
 #endif /* LIBLZMA_H */
