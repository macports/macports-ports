--- fts.c.orig	Wed Oct  6 14:13:45 2004
+++ fts.c	Wed Oct  6 14:14:00 2004
@@ -55,7 +55,7 @@
 #include "bsdtar_platform.h" /* bsdtar: need platform-specific definitions. */
 __FBSDID("$FreeBSD: src/usr.bin/tar/fts.c,v 1.2 2004/07/24 22:13:44 kientzle Exp $");
 
-#ifdef linux  /* bsdtar: translate certain system calls to Linux names. */
+#if defined(linux) || defined(__APPLE__)  /* bsdtar: translate certain system calls to Linux names. */
 #define _open open
 #define _close close
 #define _fstat fstat
