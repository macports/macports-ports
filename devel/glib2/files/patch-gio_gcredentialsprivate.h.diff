--- gio/gcredentialsprivate.h.orig	2022-03-17 23:01:31.000000000 +0800
+++ gio/gcredentialsprivate.h	2022-04-04 06:56:04.000000000 +0800
@@ -135,7 +135,7 @@
 #define G_CREDENTIALS_USE_NETBSD_UNPCBID 1
 #define G_CREDENTIALS_NATIVE_TYPE G_CREDENTIALS_TYPE_NETBSD_UNPCBID
 #define G_CREDENTIALS_NATIVE_SIZE (sizeof (struct unpcbid))
-/* #undef G_CREDENTIALS_UNIX_CREDENTIALS_MESSAGE_SUPPORTED */
+#define G_CREDENTIALS_SOCKET_GET_CREDENTIALS_SUPPORTED 1
 #define G_CREDENTIALS_SPOOFING_SUPPORTED 1
 #define G_CREDENTIALS_HAS_PID 1
 
@@ -160,6 +160,15 @@
 
 #elif defined(__APPLE__)
 #include <sys/ucred.h>
+#ifndef SOL_LOCAL
+#define SOL_LOCAL 0
+#endif
+#ifndef LOCAL_PEERCRED
+#define LOCAL_PEERCRED          0x001           /* retrieve peer credentails */
+#endif
+#ifndef LOCAL_PEERPID
+#define LOCAL_PEERPID           0x002           /* retrieve peer pid */
+#endif
 #define G_CREDENTIALS_SUPPORTED 1
 #define G_CREDENTIALS_USE_APPLE_XUCRED 1
 #define G_CREDENTIALS_NATIVE_TYPE G_CREDENTIALS_TYPE_APPLE_XUCRED
