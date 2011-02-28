--- src/applog.cpp.orig	2010-11-01 10:11:55.000000000 +1100
+++ src/applog.cpp	2011-03-01 06:37:36.000000000 +1100
@@ -45,6 +45,8 @@
 #include <cstdlib>
 #include <stdarg.h>
 #include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
 
 // TODO sc: test if has to move up now that it is into commoncpp
 // NOTE: the order of inclusion is important do not move following include line
