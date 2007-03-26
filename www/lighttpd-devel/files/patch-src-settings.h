--- src/settings.h	2007-03-26 13:21:30.000000000 +0900
+++ src/settings.h.orig	2007-03-26 13:19:54.000000000 +0900
@@ -53,6 +53,7 @@
 # if defined(HAVE_AIO_H) && (!defined(__FreeBSD__))
 /* FreeBSD has no SIGEV_THREAD for us */
 #  define USE_POSIX_AIO
+#  include <sys/types.h>
 #  include <aio.h>
 # endif
 # ifdef HAVE_MMAP
