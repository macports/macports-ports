--- gtk-xmhtml/XmHTMLP.h.org	Mon Jan 10 14:48:21 2005
+++ gtk-xmhtml/XmHTMLP.h	Mon Jan 10 14:49:00 2005
@@ -275,7 +275,8 @@
 
 #ifndef BYTE_ALREADY_TYPEDEFED
 #define BYTE_ALREADY_TYPEDEFED
-typedef unsigned char Byte;
+/* typedef unsigned char Byte; */
+#include <zconf.h>
 #endif /* BYTE_ALREADY_TYPEDEFED */
 
 _XFUNCPROTOBEGIN
