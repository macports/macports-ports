diff -ru doxygen-1.5.5/qtools/qfiledefs_p.h doxygen-dev/qtools/qfiledefs_p.h
--- qtools/qfiledefs_p.h	2007-11-18 08:15:43.000000000 -0500
+++ qtools/qfiledefs_p.h	2008-02-13 11:16:21.000000000 -0500
@@ -56,7 +56,7 @@
 # include <sys/types.h>
 # include <sys/stat.h>
 #elif defined(_OS_MAC_) \
-  && (MAC_OS_X_VERSION_MAX_ALLOWED==MAC_OS_X_VERSION_10_5)
+  && (MAC_OS_X_VERSION_MAX_ALLOWED>=MAC_OS_X_VERSION_10_4)
 # include <sys/types.h>
 # include <sys/stat.h>
 # define _OS_UNIX_
