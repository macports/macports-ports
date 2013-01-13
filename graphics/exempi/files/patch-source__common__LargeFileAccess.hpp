--- source/common/LargeFileAccess.hpp.orig	2011-11-12 22:57:42.000000000 -0800
+++ source/common/LargeFileAccess.hpp	2013-01-11 10:20:43.000000000 -0800
@@ -19,7 +19,7 @@
 	#define snprintf _snprintf
 #else
 	#if XMP_MacBuild
-		#include <Files.h>
+		#include <CoreServices/CoreServices.h>
 	#endif
 	// POSIX headers for both Mac and generic UNIX.
 	#include <pthread.h>
