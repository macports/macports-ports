--- strfile/strfile.c.orig	Tue Oct  8 17:16:57 2002
+++ strfile/strfile.c	Tue Oct  8 17:17:05 2002
@@ -452,7 +452,7 @@
 	long   tmp;
 	long   *sp;
 
-	srandomdev();
+	srandom(getpid());
 
 	Tbl.str_flags |= STR_RANDOM;
 	cnt = Tbl.str_numstr;
--- strfile/strfile.c.orig	2007-09-27 12:48:32.000000000 +0200
+++ strfile/strfile.c	2007-09-27 12:54:12.000000000 +0200
@@ -49,7 +49,15 @@
 __FBSDID("$FreeBSD: src/games/fortune/strfile/strfile.c,v 1.28 2005/02/17 18:06:37 ru Exp $");
 
 # include	<sys/param.h>
+#if defined(__FreeBSD__)
 # include	<sys/endian.h>
+#elif defined(__APPLE__) && defined(__MACH__)
+# include	<machine/endian.h>
+# define htobe32 htonl
+#else
+# include	<netinet/in.h>
+# define htobe32 htonl
+#endif
 # include	<stdio.h>
 # include       <stdlib.h>
 # include	<ctype.h>
@@ -252,6 +261,9 @@
 	Tbl.str_shortlen = htobe32(Tbl.str_shortlen);
 	Tbl.str_flags = htobe32(Tbl.str_flags);
 	(void) fwrite((char *) &Tbl, sizeof Tbl, 1, outf);
+#ifndef __FreeBSD__
+    #define htobe64(x) (((u_int64_t)htobe32((x) & (u_int64_t)0x00000000FFFFFFFFULL)) << 32) | ((u_int64_t)htobe32(((x) & (u_int64_t)0xFFFFFFFF00000000ULL) >> 32))
+#endif
 	if (STORING_PTRS) {
 		for (p = Seekpts, cnt = Num_pts; cnt--; ++p)
 			*p = htobe64(*p);
