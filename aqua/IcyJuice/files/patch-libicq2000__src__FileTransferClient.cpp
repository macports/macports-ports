--- libicq2000/src/FileTransferClient.cpp.orig	2009-08-04 16:50:01.000000000 -0700
+++ libicq2000/src/FileTransferClient.cpp	2009-08-04 16:50:35.000000000 -0700
@@ -30,6 +30,7 @@
 #include <unistd.h>
 
 #include <sys/types.h>
+#include <sys/param.h>
 #include <sys/stat.h>
 #include <dirent.h>
 
