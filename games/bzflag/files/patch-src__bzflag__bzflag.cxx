--- src/bzflag/bzflag.cxx.orig	Sat Jan 22 10:29:58 2005
+++ src/bzflag/bzflag.cxx	Sat Jan 22 10:30:16 2005
@@ -1219,14 +1219,7 @@
     PlatformFactory::getMedia()->setMediaDirectory(BZDB.get("directory"));
   } else {
 
-    // !!! fix this stupid check.. GetMacOSXDataPath() is NULL without app bundle.
-
-#if defined(__APPLE__)
-    extern char *GetMacOSXDataPath(void);
-    PlatformFactory::getMedia()->setMediaDirectory(GetMacOSXDataPath());
-    BZDB.set("directory", GetMacOSXDataPath());
-    BZDB.setPersistent("directory", false);
-#elif (defined(_WIN32) || defined(WIN32))
+#if (defined(_WIN32) || defined(WIN32))
     char exePath[MAX_PATH];
     GetModuleFileName(NULL,exePath,MAX_PATH);
     char* last = strrchr(exePath,'\\');
