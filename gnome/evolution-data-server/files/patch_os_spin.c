--- libdb/os/os_spin.c.org	Sat Sep 18 07:40:05 2004
+++ libdb/os/os_spin.c	Sat Sep 18 07:50:20 2004
@@ -13,9 +13,6 @@
 
 #ifndef NO_SYSTEM_INCLUDES
 #include <sys/types.h>
-#if defined(HAVE_PSTAT_GETDYNAMIC)
-#include <sys/pstat.h>
-#endif
 
 #include <limits.h>
 #include <unistd.h>
@@ -23,23 +20,6 @@
 
 #include "db_int.h"
 
-#if defined(HAVE_PSTAT_GETDYNAMIC)
-static int __os_pstat_getdynamic __P((void));
-
-/*
- * __os_pstat_getdynamic --
- *	HP/UX.
- */
-static int
-__os_pstat_getdynamic()
-{
-	struct pst_dynamic psd;
-
-	return (pstat_getdynamic(&psd,
-	    sizeof(psd), (size_t)1, 0) == -1 ? 1 : psd.psd_proc_cnt);
-}
-#endif
-
 #if defined(HAVE_SYSCONF) && defined(_SC_NPROCESSORS_ONLN)
 static int __os_sysconf __P((void));
 
@@ -79,9 +59,6 @@
 		return (dbenv->tas_spins);
 
 	dbenv->tas_spins = 1;
-#if defined(HAVE_PSTAT_GETDYNAMIC)
-	dbenv->tas_spins = __os_pstat_getdynamic();
-#endif
 #if defined(HAVE_SYSCONF) && defined(_SC_NPROCESSORS_ONLN)
 	dbenv->tas_spins = __os_sysconf();
 #endif
