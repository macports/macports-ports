--- unstr/unstr.c.orig	2005-02-23 21:59:03.000000000 +0100
+++ unstr/unstr.c	2007-09-27 13:12:57.000000000 +0200
@@ -62,7 +62,15 @@
  */
 
 # include	<sys/param.h>
+#if defined(__FreeBSD__)
 # include	<sys/endian.h>
+#elif defined(__APPLE__) && defined(__MACH__)
+# include	<machine/endian.h>
+# define be32toh ntohl
+#else
+# include	<netinet/in.h>
+# define be32toh ntohl
+#endif
 # include	<stdio.h>
 # include	<ctype.h>
 # include	<err.h>
@@ -117,6 +125,9 @@
 	off_t	pos;
 	char	buf[BUFSIZ];
 
+#ifndef __FreeBSD__
+    #define be64toh(x) (((u_int64_t)be32toh(x & (u_int64_t)0x00000000FFFFFFFFULL)) << 32) | ((u_int64_t)be32toh((x & (u_int64_t)0xFFFFFFFF00000000ULL) >> 32))
+#endif
 	for (i = 0; i < tbl->str_numstr; i++) {
 		(void) fread(&pos, 1, sizeof pos, Dataf);
 		(void) fseeko(Inf, be64toh(pos), 0);
