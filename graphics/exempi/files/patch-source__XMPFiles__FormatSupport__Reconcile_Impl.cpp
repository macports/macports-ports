--- source/XMPFiles/FormatSupport/Reconcile_Impl.cpp.orig	2011-11-12 22:57:42.000000000 -0800
+++ source/XMPFiles/FormatSupport/Reconcile_Impl.cpp	2013-01-11 10:59:16.000000000 -0800
@@ -15,7 +15,7 @@
 
 #if XMP_WinBuild
 #elif XMP_MacBuild
-	#include "UnicodeConverter.h"
+	#include <CoreServices/CoreServices.h>
 #endif
 
 // =================================================================================================
