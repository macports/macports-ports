--- src/include/port/darwin/sem.h.orig	Thu Nov  8 12:37:52 2001
+++ src/include/port/darwin/sem.h	Thu Aug 22 18:36:58 2002
@@ -63,6 +63,12 @@
 	short		sem_flg;		/* operation flags		*/
 };
 
+union semun {
+        int     val;            /* value for SETVAL */
+        struct  semid_ds *buf;  /* buffer for IPC_STAT & IPC_SET */
+        u_short *array;         /* array for GETALL & SETALL */
+};
+
 extern int	semctl(int semid, int semnum, int cmd, /* ... */ union semun arg);
 extern int	semget(key_t key, int nsems, int semflg);
 extern int	semop(int semid, struct sembuf * sops, size_t nsops);
