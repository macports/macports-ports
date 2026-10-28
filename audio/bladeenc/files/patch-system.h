--- bladeenc/system.h.orig	Fri Oct  4 02:21:34 2002
+++ bladeenc/system.h	Fri Oct  4 02:22:45 2002
@@ -33,7 +33,7 @@
 #ifndef		__SYSTEM__
 #define		__SYSTEM__
 
-
+#include <sys/types.h>
 
 /*==== THE SYSTEMS WE KNOW OF AND CAN AUTODETECT ==========================*/
 
@@ -320,11 +320,5 @@
 										/* just for debug purposes. Disable in release version! */
 
 typedef		unsigned	char 	uchar;
-
-#if (defined(UNIX_SYSTEM) && !defined(SYS_TYPES_H) && !defined(_SYS_TYPES_H)) || (!defined UNIX_SYSTEM  && !defined(__GNUC__))
-		typedef		unsigned short	ushort;
-		typedef		unsigned int	uint;
-#endif
-
 
 #endif		/* __SYSTEM__ */
