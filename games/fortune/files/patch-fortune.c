--- fortune/fortune.c.orig	Tue Oct  8 17:16:06 2002
+++ fortune/fortune.c	Tue Oct  8 17:16:21 2002
@@ -204,7 +204,7 @@
 #endif
 
 	init_prob();
-	srandomdev();
+	srandom(getpid());
 	do {
 		get_fort();
 	} while ((Short_only && fortlen() > SLEN) ||
--- fortune/fortune.c.orig	2007-09-27 12:17:07.000000000 +0200
+++ fortune/fortune.c	2007-09-27 12:42:58.000000000 +0200
@@ -49,7 +49,15 @@
 __FBSDID("$FreeBSD: src/games/fortune/fortune/fortune.c,v 1.27 2005/02/17 18:06:37 ru Exp $");
 
 # include	<sys/stat.h>
+#if defined(__FreeBSD__)
 # include	<sys/endian.h>
+#elif defined(__APPLE__) && defined(__MACH__)
+# include	<machine/endian.h>
+# define be32toh ntohl
+#else
+# include	<netinet/in.h>
+# define be32toh ntohl
+#endif
 
 # include	<dirent.h>
 # include	<fcntl.h>
@@ -979,6 +987,9 @@
 	(void) lseek(fp->datfd,
 		     (off_t) (sizeof fp->tbl + fp->pos * sizeof Seekpts[0]), 0);
 	read(fp->datfd, Seekpts, sizeof Seekpts);
+#ifndef __FreeBSD__
+    #define be64toh(x) (((u_int64_t)be32toh((x) & (u_int64_t)0x00000000FFFFFFFFULL)) << 32) | ((u_int64_t)be32toh(((x) & (u_int64_t)0xFFFFFFFF00000000ULL) >> 32))
+#endif
 	Seekpts[0] = be64toh(Seekpts[0]);
 	Seekpts[1] = be64toh(Seekpts[1]);
 }
