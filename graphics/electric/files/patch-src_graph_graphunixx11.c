--- src/graph/graphunixx11.c.orig	Thu May 22 12:35:30 2003
+++ src/graph/graphunixx11.c	Mon Feb  9 18:45:31 2004
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
@@ -3067,10 +3071,24 @@
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
