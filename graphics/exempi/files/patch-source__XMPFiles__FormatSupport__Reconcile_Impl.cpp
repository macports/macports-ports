--- bogus/source/XMPFiles/FormatSupport/Reconcile_Impl.cpp.orig	2009-02-17 04:10:42.000000000 +0000
+++ bogus/source/XMPFiles/FormatSupport/Reconcile_Impl.cpp	2009-10-02 22:25:43.000000000 +0100
@@ -16,6 +16,7 @@
 #if XMP_WinBuild
 #elif XMP_MacBuild
 	#include "UnicodeConverter.h"
+	#include "Script.h"
 #elif XMP_UNIXBuild
   #include <stdlib.h>
   #include <iconv.h>
