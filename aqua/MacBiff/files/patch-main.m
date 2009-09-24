--- main.m.orig	2009-09-24 13:55:00.000000000 -0700
+++ main.m	2009-09-24 13:55:40.000000000 -0700
@@ -28,10 +28,11 @@
 #endif
 #include "debug.h"
 
-FILE *_dbgfp = stderr;
+FILE *_dbgfp;
 
 int main(int argc, const char *argv[])
 {
+	_dbgfp = stderr;
 #if defined(EBUG) && EBUG && defined(EBUGFILE)
 	char debugfile[64];
 	snprintf(debugfile, 64, "/tmp/MacBiff.debug.%u", getpid());
