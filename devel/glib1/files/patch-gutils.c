--- gutils.c.orig	Wed Aug  9 14:12:31 2000
+++ gutils.c	Sat Apr 19 06:09:28 2003
@@ -483,6 +483,7 @@
 #    ifdef _SC_GETPW_R_SIZE_MAX  
         /* This reurns the maximum length */
         guint bufsize = sysconf (_SC_GETPW_R_SIZE_MAX);
+	if (bufsize == UINT_MAX) bufsize = 64; /* XXX Correct for unimpelemented SC */
 #    else /* _SC_GETPW_R_SIZE_MAX */
         guint bufsize = 64;
 #    endif /* _SC_GETPW_R_SIZE_MAX */
