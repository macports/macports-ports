--- setup.py.orig	2009-09-06 15:56:18.000000000 -0700
+++ setup.py	2009-09-06 15:56:27.000000000 -0700
@@ -87,8 +87,8 @@
 CFLAGS=[
     "-DPyObjC_STRICT_DEBUGGING",
     "-DMACOSX",
-    "-no-cpp-precomp",
-    "-Wno-long-double",
+    #"-no-cpp-precomp",
+    #"-Wno-long-double",
     #"-Wselector",
     "-g",
     #"-fobjc-gc",
