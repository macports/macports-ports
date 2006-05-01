--- src/js/jsMacOSX.cxx.orig	2004-09-21 05:45:55.000000000 -0600
+++ src/js/jsMacOSX.cxx	2006-04-30 18:46:43.000000000 -0600
@@ -275,7 +275,7 @@
 		&elementEnumerator, joy);
 }
 
-static void os_specific_s::elementEnumerator( const void *element, void* vjs)
+void os_specific_s::elementEnumerator( const void *element, void* vjs)
 {
 	if (CFGetTypeID((CFTypeRef) element) != CFDictionaryGetTypeID()) {
 		ulSetError(UL_WARNING, "element enumerator passed non-dictionary value");
