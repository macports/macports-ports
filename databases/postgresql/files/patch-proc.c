--- postgresql-7.2.1/src/backend/storage/lmgr/proc.c.orig	Fri Dec 28 10:16:43 2001
+++ postgresql-7.2.1/src/backend/storage/lmgr/proc.c	Thu Aug 22 18:41:05 2002
@@ -53,9 +53,6 @@
 
 #include "storage/ipc.h"
 /* In Ultrix, sem.h and shm.h must be included AFTER ipc.h */
-#ifdef HAVE_SYS_SEM_H
-#include <sys/sem.h>
-#endif
 
 #if defined(__darwin__)
 #include "port/darwin/sem.h"
