diff -rwub pkg_install/Makefile.inc pkg_install-wrk/Makefile.inc
--- Makefile.inc	Fri Aug 27 18:17:53 1999
+++ Makefile.inc	Thu Aug 15 00:13:54 2002
@@ -6,5 +6,4 @@
 LIBINSTALL=	${.CURDIR}/../lib/libinstall.a
 .endif
 
-# Inherit BINDIR from one level up.
-.include "../Makefile.inc"
+BINDIR=		/usr/local/sbin
