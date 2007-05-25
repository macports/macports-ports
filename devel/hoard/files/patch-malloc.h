diff -ruN hoard-3.6.1.orig/src/heaplayers/wrapper.cpp hoard-3.6.1/src/heaplayers/wrapper.cpp
--- hoard-3.6.1.orig/src/heaplayers/wrapper.cpp	2007-05-21 18:47:06.000000000 -0700
+++ hoard-3.6.1/src/heaplayers/wrapper.cpp	2007-05-25 16:03:55.000000000 -0700
@@ -31,7 +31,12 @@
  */
 
 #include <string.h> // for memcpy
+
+#if defined(_WIN32) || defined(linux)
 #include <malloc.h> // for memalign
+#elif defined(__APPLE__)
+#include <malloc/malloc.h>
+#endif
 
 #ifdef _WIN32
 #define WIN32_LEAN_AND_MEAN
diff -ruN hoard-3.6.1.orig/src/hoarddetours.cpp hoard-3.6.1/src/hoarddetours.cpp
--- hoard-3.6.1.orig/src/hoarddetours.cpp	2007-05-21 18:47:06.000000000 -0700
+++ hoard-3.6.1/src/hoarddetours.cpp	2007-05-25 16:04:13.000000000 -0700
@@ -29,7 +29,11 @@
 
 #include <windows.h>
 #include <stdio.h>
+#if defined(_WIN32) || defined(linux)
 #include <malloc.h>
+#elif defined(__APPLE__)
+#include <malloc/malloc.h>
+#endif
 #include "detours.h"
 
 #if defined(_WIN32)
