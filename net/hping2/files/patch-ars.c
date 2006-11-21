--- ars.c.orig	2006-11-20 13:20:01.000000000 -0700
+++ ars.c	2006-11-20 13:20:46.000000000 -0700
@@ -830,7 +830,7 @@
 		return -ARS_INVALID;
 	}
 	ip = (struct ars_iphdr*) packet;
-#if defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
+#if defined OSTYPE_DARWIN || defined  OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
 	ip->tot_len = ntohs(ip->tot_len);
 	ip->frag_off = ntohs(ip->frag_off);
 #endif
