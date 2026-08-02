--- sendip.c.orig	2004-04-10 01:38:56.000000000 +0200
+++ sendip.c	2007-04-05 21:05:10.000000000 +0200
@@ -48,7 +48,7 @@
 	ip->ihl		= (IPHDR_SIZE + optlen + 3) >> 2;
 	ip->tos		= ip_tos;
 
-#if defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
+#if defined OSTYPE_DARWIN || OSTYPE_FREEBSD || defined OSTYPE_NETBSD || defined OSTYPE_BSDI
 /* FreeBSD */
 /* NetBSD */
 	ip->tot_len	= packetsize;
@@ -73,7 +73,7 @@
 			htons((unsigned short) src_id);
 	}
 
-#if defined OSTYPE_FREEBSD || defined OSTYPE_NETBSD | defined OSTYPE_BSDI
+#if defined OSTYPE_DARWIN || OSTYPE_FREEBSD || defined OSTYPE_NETBSD | defined OSTYPE_BSDI
 /* FreeBSD */
 /* NetBSD */
 	ip->frag_off	|= more_fragments;
