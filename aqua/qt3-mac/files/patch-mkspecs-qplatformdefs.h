--- mkspecs/macx-g++/qplatformdefs.h.orig	2005-06-16 09:26:25.000000000 -0700
+++ mkspecs/macx-g++/qplatformdefs.h	2005-06-16 09:26:42.000000000 -0700
@@ -75,7 +75,7 @@
 #define QT_SIGNAL_ARGS		int
 #define QT_SIGNAL_IGNORE	(void (*)(int))1
 
-#define QT_SOCKLEN_T		int
+#define QT_SOCKLEN_T		socklen_t
 
 #define QT_SNPRINTF		::snprintf
 #define QT_VSNPRINTF		::vsnprintf
