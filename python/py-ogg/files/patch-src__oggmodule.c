--- src/_oggmodule.c.orig	Sat Jan 18 17:50:15 2003
+++ src/_oggmodule.c	Tue Jan 27 18:33:10 2004
@@ -31,6 +31,8 @@
   arg_to_int64,
 };
 
+PyObject *Py_OggError;
+
 void
 init_ogg(void)
 {
