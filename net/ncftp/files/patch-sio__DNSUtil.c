--- sio/DNSUtil.c.orig	Sun Dec 26 20:32:42 2004
+++ sio/DNSUtil.c	Sun Dec 26 20:32:51 2004
@@ -16,7 +16,7 @@
 	}
 #endif
 
-#if (((defined(MACOSX)) && (MACSOX < 10300)) || (defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
+#if (((defined(MACOSX)) && (MACOSX < 10300)) || (defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
 extern int getdomainname(char *name, gethostname_size_t namelen);
 #endif
 
