--- a/source/XMPFiles/XMPFiles_Impl.hpp.orig	2012-02-13 23:32:15.000000000 -0800
+++ b/source/XMPFiles/XMPFiles_Impl.hpp	2012-02-13 23:33:03.000000000 -0800
@@ -35,7 +35,7 @@
 	#define snprintf _snprintf
 #else
 	#if XMP_MacBuild
-		#include <Files.h>
+		#include <CoreServices/CoreServices.h>
 	#endif
 	// POSIX headers for both Mac and generic UNIX.
 	#include <pthread.h>
