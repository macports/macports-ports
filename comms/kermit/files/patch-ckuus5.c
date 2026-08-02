--- ckuus5.c.orig	2011-09-08 08:32:20.000000000 -0500
+++ ckuus5.c	2011-09-08 08:33:05.000000000 -0500
@@ -840,6 +840,7 @@
 char * k_info_dir = NULL;               /* Where to find text files */
 #ifdef UNIX
 static char * txtdir[] = {
+    "@@prefix@@/share/kermit"           /* Mac OS X MacPorts */
     "/usr/local/doc/",                  /* Linux, SunOS, ... */
     "/usr/share/lib/",                  /* HP-UX 10.xx... */
     "/usr/share/doc/",                  /* Other possibilities... */
