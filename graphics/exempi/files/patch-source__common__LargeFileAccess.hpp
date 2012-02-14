--- a/source/common/LargeFileAccess.hpp.orig	2012-02-13 23:24:53.000000000 -0800
+++ b/source/common/LargeFileAccess.hpp	2012-02-13 23:25:03.000000000 -0800
@@ -42,9 +42,9 @@ using namespace std;
 	#include <Windows.h>
 	#define snprintf _snprintf
 #else
	#if XMP_MacBuild
-		#include <Files.h>
+		#include <CoreServices/CoreServices.h>
	#endif
 	// POSIX headers for both Mac and generic UNIX.
 	#include <pthread.h>
 	#include <fcntl.h>
