--- gio/gsocket.h.orig	2022-03-17 23:01:31.000000000 +0800
+++ gio/gsocket.h	2022-04-04 06:55:30.000000000 +0800
@@ -43,6 +43,15 @@
 #define G_SOCKET_GET_CLASS(inst)                            (G_TYPE_INSTANCE_GET_CLASS ((inst),                      \
                                                              G_TYPE_SOCKET, GSocketClass))
 
+#if defined(__APPLE__)
+#ifndef LOCAL_PEERCRED
+#define LOCAL_PEERCRED          0x001           /* retrieve peer credentails */
+#endif
+#ifndef LOCAL_PEERPID
+#define LOCAL_PEERPID           0x002           /* retrieve peer pid */
+#endif
+#endif
+
 typedef struct _GSocketPrivate                              GSocketPrivate;
 typedef struct _GSocketClass                                GSocketClass;
 
