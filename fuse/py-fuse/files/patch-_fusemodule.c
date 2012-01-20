--- fuseparts/_fusemodule.c.old	2007-07-15 15:09:32.000000000 -0700
+++ fuseparts/_fusemodule.c	2007-07-15 15:10:56.000000000 -0700
@@ -32,7 +32,9 @@
 #define FUSE_USE_VERSION 26
 #endif
 
+#undef __FreeBSD__
 #include <Python.h>
+#define __FreeBSD__ 10
 #include <fuse.h>
 
 static PyObject *getattr_cb=NULL, *readlink_cb=NULL, *readdir_cb=NULL,
