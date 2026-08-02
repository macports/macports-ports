--- rpmopen.c.orig	2010-11-09 13:57:42.000000000 -0800
+++ rpmopen.c	2018-09-21 00:08:40.000000000 -0700
@@ -29,6 +29,7 @@
 #ifdef HAVE_RPM42
 #include <rpm/rpmfi.h>
 #endif
+#include <rpm/rpmevr.h>
 
 #ifndef HAVE_RPM_RPMLEGACY_H
 int readLead(FD_t fd, /*@out@*/struct rpmlead *lead);
