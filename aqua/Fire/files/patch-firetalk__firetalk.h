--- firetalk/firetalk.h.orig	2005-04-03 19:23:48.000000000 -0400
+++ firetalk/firetalk.h	2005-04-03 19:25:21.000000000 -0400
@@ -21,6 +21,14 @@
 #include <unistd.h>
 #include <sys/time.h>
 
+#ifndef TRUE
+#define TRUE 1
+#endif
+
+#ifndef FALSE
+#define FALSE 0
+#endif
+
 #define LIBFIRETALK_VERSION "0.0.16 (dcc)"
 #define LIBFIRETALK_HOMEPAGE "http://www.penguinhosting.net/~ian/firetalk/"
 
