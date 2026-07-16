--- ars.c.orig	2004-04-14 14:30:18.000000000 +0200
+++ ars.c	2007-04-05 21:05:19.000000000 +0200
@@ -914,7 +914,7 @@
 		return -ARS_INVALID;
 	}
 	ip = (struct ars_iphdr*) packet;
-#if defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
+#if defined OSTYPE_DARWIN || OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
 	ip->tot_len = ntohs(ip->tot_len);
 	ip->frag_off = ntohs(ip->frag_off);
 #endif
