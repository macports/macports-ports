--- elhttp.c	Wed Feb 23 12:00:00 2005
+++ ../../elhttp.c	Sat Feb 26 16:51:52 2005
@@ -27,6 +27,7 @@
 #include <sys/wait.h>
 #include <unistd.h>
 #include <netdb.h>
+#include <pthread.h>
 
 #define recv(a,b,c,d) read(a,b,c)
 #define send(a,b,c,d) write(a,b,c)
