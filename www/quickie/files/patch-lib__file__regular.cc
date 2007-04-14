--- lib/file/regular.cc	2006-05-20 22:56:52.000000000 +0000
+++ lib/file/regular.cc.new	2007-03-30 16:02:22.000000000 +0000
@@ -28,6 +28,7 @@
 #include <ctime>
 #include <fcntl.h>
 #include <unistd.h>
+#include <sys/stat.h>
 
 #include <careful.h>
 #include <cgi.h>
