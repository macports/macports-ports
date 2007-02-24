--- fuseparts/_fusemodule.c.bak	2007-02-24 13:59:44.000000000 -0500
+++ fuseparts/_fusemodule.c	2007-02-24 14:00:06.000000000 -0500
@@ -22,7 +22,9 @@
 #define FUSE_USE_VERSION 26
 #endif
 
+#undef __FreeBSD__
 #include <Python.h>
+#define __FreeBSD__ 10
 #include <fuse.h>
 
 static PyObject *getattr_cb=NULL, *readlink_cb=NULL, *readdir_cb=NULL,
