--- src/toextract.cpp.orig	2018-07-19 16:07:16.000000000 +0700
+++ src/toextract.cpp	2018-07-19 16:07:31.000000000 +0700
@@ -46,6 +46,7 @@
 #include "toextract.h"
 
 #include <stdio.h>
+#include <unistd.h>
 
 #include <qapplication.h>
 #include <qlabel.h>
