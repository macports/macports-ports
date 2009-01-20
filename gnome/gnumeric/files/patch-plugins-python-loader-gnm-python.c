--- plugins/python-loader/gnm-python.c.orig	2008-01-15 00:55:07.000000000 +0100
+++ plugins/python-loader/gnm-python.c	2008-02-02 17:20:51.000000000 +0100
@@ -7,6 +7,7 @@
 
 #include <gnumeric-config.h>
 #include <Python.h>
+#define NO_IMPORT_PYGOBJECT
 #include <pygobject.h>
 #include <glib.h>
 #include "gnm-py-interpreter.h"
