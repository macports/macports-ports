--- unicodedata2/py3/unicodedata.c.orig	2020-03-20 18:40:50 UTC
+++ unicodedata2/py3/unicodedata.c
@@ -16,7 +16,12 @@
 #define PY_SSIZE_T_CLEAN
 
 #include "Python.h"
+#if PY_MINOR_VERSION < 10
 #include "ucnhash.h"
+#else
+#define Py_BUILD_CORE
+#include "internal/pycore_ucnhash.h"
+#endif
 #include "structmember.h"
 #include "unicodectype.h"
 
