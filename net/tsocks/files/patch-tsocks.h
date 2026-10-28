--- tsocks.h.orig	2007-03-28 12:26:58.000000000 +0100
+++ tsocks.h	2007-03-28 12:16:46.000000000 +0100
@@ -75,9 +75,9 @@
 #define FAILED 14 
    
 /* Flags to indicate what events a socket was select()ed for */
-#define READ (1<<0)
-#define WRITE (1<<1)
-#define EXCEPT (1<<2)
+#define READ (POLLIN|POLLRDNORM)
+#define WRITE (POLLOUT|POLLWRNORM|POLLWRBAND)
+#define EXCEPT (POLLRDBAND|POLLPRI)
 #define READWRITE (READ|WRITE)
 #define READWRITEEXCEPT (READ|WRITE|EXCEPT)
 
