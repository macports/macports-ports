--- backend/dell1600n_net.c.orig	2006-06-20 06:07:52.000000000 +0900
+++ backend/dell1600n_net.c	2007-03-13 11:55:28.000000000 +0900
@@ -73,6 +73,8 @@
 #include <netinet/in.h>
 #include <netdb.h>
 
+#include <sys/time.h>
+
 #include <jpeglib.h>
 #include <tiffio.h>
 
@@ -1762,7 +1764,7 @@
 ProcessPageData (struct ScannerState *pState)
 {
 
-  char tempFilename[TMP_MAX] = "scan.dat";
+  char tempFilename[L_tmpnam] = "scan.dat";
   FILE *fTmp;
   int fdTmp;
   struct jpeg_source_mgr jpegSrcMgr;
