--- gtk/xdgmime/xdgmimemagic.c~	Wed Aug 25 19:52:22 2004
+++ gtk/xdgmime/xdgmimemagic.c	Sun Sep 19 16:53:28 2004
@@ -44,6 +44,10 @@
 #define	TRUE	(!FALSE)
 #endif
 
+#ifndef HAVE_FLOCKFILE
+#define getc_unlocked getc
+#endif
+
 extern int errno;
 
 typedef struct XdgMimeMagicMatch XdgMimeMagicMatch;
