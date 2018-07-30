--- src/toreport.cpp.orig	2018-07-19 16:08:26.000000000 +0700
+++ src/toreport.cpp	2018-07-19 16:08:40.000000000 +0700
@@ -47,6 +47,8 @@
 #include "toextract.h"
 #include "toreport.h"
 
+#include <unistd.h>
+
 #include <qapplication.h>
 #include <qdatetime.h>
 #ifdef Q_OS_WIN32
