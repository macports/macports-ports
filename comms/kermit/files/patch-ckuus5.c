--- ckuus5.c.orig	Fri Nov 14 10:20:20 2003
+++ ckuus5.c	Fri Nov 14 16:06:56 2003
@@ -814,6 +814,7 @@
 char * k_info_dir = NULL;               /* Where to find text files */
 #ifdef UNIX
 static char * txtdir[] = {
+    "@@prefix@@/share/kermit"		/* MacOS X DarwinPorts*/
     "/usr/local/doc/",                  /* Linux, SunOS, ... */
     "/usr/share/lib/",                  /* HP-UX 10.xx... */
     "/usr/share/doc/",                  /* Other possibilities... */
