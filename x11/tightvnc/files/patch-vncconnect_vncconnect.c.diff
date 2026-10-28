--- ../vnc_unixsrc/vncconnect/vncconnect.c	2000-11-10 10:20:07.000000000 +0000
+++ vncconnect/vncconnect.c	2007-05-15 13:09:59.000000000 +0000
@@ -2,6 +2,12 @@
  * vncconnect.c
  */
 
+/* On Darwin, exit() is prototyped in <stdlib.h> and strlen() in <string.h> */
+#if defined(__DARWIN__) || defined(__APPLE__)
+#include <string.h>
+#include <stdlib.h>
+#endif /* __DARWIN__ || __APPLE__ */
+
 #include <stdio.h>
 #include <X11/Xlib.h>
 #include <X11/Xatom.h>
