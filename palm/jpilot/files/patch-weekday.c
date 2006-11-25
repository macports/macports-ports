--- jpilot.c.orig	2006-06-09 16:42:57.000000000 -0400
+++ jpilot.c	2006-11-19 21:11:19.000000000 -0500
@@ -2180,7 +2180,7 @@
 
    /* Extract first day of week preference from locale in GTK2 */
 #  ifdef ENABLE_GTK2
-#     ifdef HAVE_LANGINFO_H
+#     if defined(HAVE_LANGINFO_H) && defined(_NL_TIME_FIRST_WEEKDAY)
 	 /* GTK 2.8 libraries */
 	 week_start = nl_langinfo (_NL_TIME_FIRST_WEEKDAY);
 	 pref_fdow = *((unsigned char *) week_start) - 1;
