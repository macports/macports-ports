--- sendip.c.orig	2006-11-20 13:23:28.000000000 -0700
+++ sendip.c	2006-11-20 13:23:05.000000000 -0700
@@ -48,7 +48,8 @@
 	ip->ihl		= (IPHDR_SIZE + optlen + 3) >> 2;
 	ip->tos		= ip_tos;
 
-#if defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
+#if defined OSTYPE_DARWIN || defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
+/* OS X */
 /* FreeBSD */
 /* NetBSD */
 	ip->tot_len	= packetsize;
@@ -73,7 +74,8 @@
 			htons((unsigned short) src_id);
 	}
 
-#if defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD | defined OSTYPE_BSDI
+#if defined OSTYPE_DARWIN || defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD | defined OSTYPE_BSDI
+/* OS X */
 /* FreeBSD */
 /* NetBSD */
 	ip->frag_off	|= more_fragments;
