--- src/display.c.orig	Sun Sep  3 01:50:07 2006
+++ src/display.c	Sun Sep  3 01:58:30 2006
@@ -428,7 +428,7 @@
 		PyDict_SetItemString(dict, "window", PyInt_FromLong(info.window));
 		PyDict_SetItemString(dict, "wimpVersion", PyInt_FromLong(info.wimpVersion));
 		PyDict_SetItemString(dict, "taskHandle", PyInt_FromLong(info.taskHandle));
-#else
+#elif !(defined(__APPLE__) && defined(__MACH__))
 		PyDict_SetItemString(dict, "data", PyInt_FromLong(info.data));
 #endif
