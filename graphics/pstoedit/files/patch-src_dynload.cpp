--- src/dynload.cpp.orig	Mon Jan  6 14:21:15 2003
+++ src/dynload.cpp	Sun Feb  8 01:17:57 2004
@@ -79,6 +79,8 @@
 #define WINLOADLIB LoadLibrary
 #define WINFREELIB FreeLibrary
 	//  static const char * const libsuffix = ".dll";
+#elif defined(__APPLE__)
+#include <dlfcn.h>
 #else
 #error "system unsupported so far"
 #endif
@@ -117,6 +119,9 @@
 	handle = dlopen(fulllibname, loadmode);
 #elif defined(_WIN32)
 	handle = WINLOADLIB(fulllibname);
+#elif defined(__APPLE__)
+	int loadmode = RTLD_LAZY;	// RTLD_NOW
+	handle = dlopen(fulllibname, loadmode);
 #else
 	system unsupported so far
 #endif
@@ -156,6 +161,8 @@
 		dlclose(handle);
 #elif defined(_WIN32)
 		WINFREELIB((HINSTANCE) handle);
+#elif defined(__APPLE__)
+		dlclose(handle);
 #elif
 		system unsupported so far
 #endif
@@ -187,6 +194,8 @@
 	DynLoader::fptr rfptr = (DynLoader::fptr) dlsym(handle, name);	//lint !e611 //: Suspicious cast
 #elif defined(_WIN32)
 	DynLoader::fptr rfptr = (DynLoader::fptr) GetProcAddress((HINSTANCE) handle, name);	//lint !e611 //: Suspicious cast
+#elif defined(__APPLE__)
+	DynLoader::fptr rfptr = (DynLoader::fptr) dlsym(handle, name);  //lint !e611 //: Suspicious cast
 #else
 	system unsupported so far
 #endif
@@ -265,7 +274,7 @@
 }
 
 
-#if defined(__linux) || defined(__linux__)  || defined(__FreeBSD__) || defined(__sparc) || defined(__hpux) || defined(__OS2__)
+#if defined(__linux) || defined(__linux__)  || defined(__FreeBSD__) || defined(__sparc) || defined(__hpux) || defined(__OS2__) || defined(__APPLE__)
 // for directory search
 #if HAVE_DIRENT_H
 #include <dirent.h>
