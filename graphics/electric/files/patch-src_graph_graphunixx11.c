--- src/graph/graphunixx11.c.orig	Thu Jul 15 19:59:53 2004
+++ src/graph/graphunixx11.c	Sat Nov  6 20:16:31 2004
@@ -151,6 +151,10 @@
   INTBIG gra_initializetcl(void);
 #endif
 
+#ifdef __APPLE__
+#  include <sys/sysctl.h>
+#endif
+
 #ifdef _UNICODE
 #  define estat     _wstat
 #  define eaccess   _waccess
@@ -3087,10 +3091,24 @@
  */
 INTBIG enumprocessors(void)
 {
+#ifdef __APPLE__
+	int ctlName[ 2 ], numproc, result;
+	size_t numSize;
+
+	ctlName[ 0 ] = CTL_HW;
+	ctlName[ 1 ] = HW_NCPU;
+	numSize = sizeof( numproc );
+	result = sysctl( ctlName, 2, &numproc, &numSize, NULL, 0 );
+	if( result == 0 )
+		return( (INTBIG) numproc );
+	else
+		return( 1 );
+#else
 	INTBIG numproc;
 
 	numproc = sysconf(_SC_NPROCESSORS_ONLN);
 	return(numproc);
+#endif
 }
 
 /*
