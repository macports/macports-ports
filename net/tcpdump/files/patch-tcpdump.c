--- tcpdump.c.orig	Wed Apr  7 03:47:10 2004
+++ tcpdump.c	Wed Apr  7 03:47:27 2004
@@ -290,6 +290,12 @@
 #endif /* WIN32 */
 
 #ifdef HAVE_PCAP_FINDALLDEVS
+#ifndef HAVE_PCAP_IF_T
+#undef HAVE_PCAP_FINDALLDEVS
+#endif
+#endif
+
+#ifdef HAVE_PCAP_FINDALLDEVS
 #define D_FLAG	"D"
 #else
 #define D_FLAG
