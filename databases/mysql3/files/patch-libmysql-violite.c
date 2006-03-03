--- libmysql/violite.c.orig	Sun Aug 31 10:29:51 2003
+++ libmysql/violite.c	Sun Aug 31 10:30:05 2003
@@ -33,7 +33,7 @@
 #include <my_net.h>
 #include <m_string.h>
 #ifdef HAVE_POLL
-#include <sys/poll.h>
+#include <poll.h>
 #endif
 #ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
