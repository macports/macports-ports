--- libmpdemux/frequencies.h.orig	2001-11-16 15:06:48.000000000 -0700
+++ libmpdemux/frequencies.h	2005-06-13 01:26:52.000000000 -0600
@@ -104,7 +104,7 @@
 /* --------------------------------------------------------------------- */
 
 extern struct CHANLISTS   chanlists[];
-extern struct STRTAB chanlist_names[];
+/*extern struct STRTAB chanlist_names[];*/
 
 extern int                chantab;
 extern struct CHANLIST   *chanlist;
