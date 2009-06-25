--- src/torrent/poll_kqueue.cc.orig	2009-06-25 16:12:28.000000000 -0700
+++ src/torrent/poll_kqueue.cc	2009-06-25 16:12:43.000000000 -0700
@@ -39,6 +39,7 @@
 #include <cerrno>
 
 #include <algorithm>
+#include <assert.h>
 #include <unistd.h>
 #include <rak/error_number.h>
 #include <rak/functional.h>
