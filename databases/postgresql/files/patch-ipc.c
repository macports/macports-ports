--- src/backend/storage/ipc/ipc.c.orig	Mon Nov  5 09:46:28 2001
+++ src/backend/storage/ipc/ipc.c	Thu Aug 22 18:40:16 2002
@@ -34,9 +34,6 @@
 
 #include "storage/ipc.h"
 /* In Ultrix, sem.h and shm.h must be included AFTER ipc.h */
-#ifdef HAVE_SYS_SEM_H
-#include <sys/sem.h>
-#endif
 #ifdef HAVE_SYS_SHM_H
 #include <sys/shm.h>
 #endif
