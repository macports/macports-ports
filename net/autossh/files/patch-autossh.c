--- autossh.c	2005-10-13 10:18:56.000000000 +0100
+++ autossh.c	2005-10-13 10:13:19.000000000 +0100
@@ -25,9 +25,6 @@
 
 #include <sys/types.h>
 #include <sys/time.h>
-#if defined(__APPLE__) && !defined(_BSD_SOCKLEN_T)
-typedef int32_t socklen_t;
-#endif
 #include <sys/socket.h>
 #include <sys/utsname.h>
 #include <netinet/in.h>
