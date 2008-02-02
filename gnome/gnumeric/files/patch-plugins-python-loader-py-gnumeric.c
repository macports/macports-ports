--- plugins/python-loader/py-gnumeric.c.orig	2008-01-15 00:55:07.000000000 +0100
+++ plugins/python-loader/py-gnumeric.c	2008-02-02 17:23:13.000000000 +0100
@@ -9,6 +9,7 @@
 #include <Python.h>
 #include <gnumeric.h>
 #include <glib.h>
+#define NO_IMPORT_PYGOBJECT
 #include "pygobject.h"
 #include "application.h"
 #include "workbook.h"
