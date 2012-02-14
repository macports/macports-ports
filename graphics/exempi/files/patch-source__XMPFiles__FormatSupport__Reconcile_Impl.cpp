--- exempi-2.1.1/source/XMPFiles/FormatSupport/Reconcile_Impl.cpp.orig	2012-02-13 23:37:08.000000000 -0800
+++ exempi-2.1.1/source/XMPFiles/FormatSupport/Reconcile_Impl.cpp	2012-02-13 23:37:50.000000000 -0800
@@ -15,7 +15,7 @@
 
 #if XMP_WinBuild
 #elif XMP_MacBuild
-	#include "UnicodeConverter.h"
+	#include <CoreServices/CoreServices.h>
 #elif XMP_UNIXBuild
   #include <stdlib.h>
   #include <iconv.h>
