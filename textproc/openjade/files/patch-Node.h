--- grove/Node.h.orig	Mon Oct 21 06:47:24 2002
+++ grove/Node.h	Tue Aug  5 11:27:44 2003
@@ -8,7 +8,8 @@
 #endif
 
 #include <stddef.h>
-#include "IList.h"
+#include <limits.h>
+#include <OpenSP/IList.h>
 
 #ifdef SP_USE_DLL
 #ifdef BUILD_LIBGROVE
@@ -34,10 +35,10 @@
 #endif
 
 #ifdef SP_MULTI_BYTE
-#ifdef SP_WCHAR_T_USHORT
-typedef wchar_t GroveChar;
-#else
+#if UINT_MAX >= 0xffffffffL /* 2^32 - 1 */
 typedef unsigned int GroveChar;
+#else
+typedef unsigned long GroveChar;
 #endif
 #else /* not SP_MULTI_BYTE */
 typedef unsigned char GroveChar;
