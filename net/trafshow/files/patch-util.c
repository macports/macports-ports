--- util.c.orig	Fri Sep 15 06:51:11 2000
+++ util.c	Thu Sep 21 14:35:33 2000
@@ -129,6 +129,9 @@
 #ifdef	IPPROTO_ENCAP
 	{ "encap",IPPROTO_ENCAP},
 #endif
+#ifdef	IPPROTO_IPV6
+	{ "ipv6", IPPROTO_IPV6},
+#endif
 	{ "ip",   IPPROTO_IP   },
 	{ "raw",  IPPROTO_RAW  },
 	{ NULL, -1 },
