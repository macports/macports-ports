--- postgresql-7.2.1/src/backend/storage/lmgr/spin.c.orig	Mon Nov  5 09:46:28 2001
+++ postgresql-7.2.1/src/backend/storage/lmgr/spin.c	Thu Aug 22 18:41:45 2002
@@ -25,9 +25,6 @@
 
 #include "storage/ipc.h"
 /* In Ultrix, sem.h and shm.h must be included AFTER ipc.h */
-#ifdef HAVE_SYS_SEM_H
-#include <sys/sem.h>
-#endif
 
 #if defined(__darwin__)
 #include "port/darwin/sem.h"
