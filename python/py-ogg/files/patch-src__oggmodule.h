--- src/_oggmodule.h.orig	Tue Mar 27 16:54:39 2001
+++ src/_oggmodule.h	Tue Jan 27 18:35:20 2004
@@ -3,7 +3,7 @@
 
 #include <Python.h>
 
-PyObject *Py_OggError;
+extern PyObject *Py_OggError;
 
 /* Object docstrings */
 
