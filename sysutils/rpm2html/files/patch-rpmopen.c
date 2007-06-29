--- rpmopen.c.orig	2007-04-14 19:21:50.000000000 +0200
+++ rpmopen.c	2007-06-25 14:07:57.000000000 +0200
@@ -29,6 +29,7 @@
 #ifdef HAVE_RPM42
 #include <rpm/rpmfi.h>
 #endif
+#include <rpm/rpmevr.h>
 
 int readLead(FD_t fd, /*@out@*/struct rpmlead *lead);
 #ifdef HAVE_RPM42
@@ -642,7 +642,7 @@
         rpm->extra->packager = xmlStrdup(protectEmail((char *) p));
     }
     ENTRY_CLEANUP(p);
-    if (!headerGetEntry(h, RPMTAG_COPYRIGHT, &type, &p, &count) || !p ||
+    if (!headerGetEntry(h, RPMTAG_LICENSE, &type, &p, &count) || !p ||
         (type != RPM_STRING_TYPE)) {
         rpm->extra->copyright = NULL;
     } else {
