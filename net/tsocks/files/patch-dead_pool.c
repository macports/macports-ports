--- dead_pool.c.orig	2007-03-28 12:43:06.000000000 +0100
+++ dead_pool.c	2007-03-28 12:43:21.000000000 +0100
@@ -68,7 +68,7 @@
     /* Allocate space for the dead_pool structure */
     newpool = (dead_pool *) mmap(0, sizeof(dead_pool), 
                    PROT_READ | PROT_WRITE, 
-                   MAP_SHARED | MAP_ANONYMOUS, -1, 0); 
+                   MAP_SHARED | MAP_ANON, -1, 0); 
     if(!newpool) {
         show_msg(MSGERR, "init_pool: unable to mmap deadpool "
                  "(tried to map %d bytes)\n", sizeof(dead_pool));
@@ -93,7 +93,7 @@
     /* Allocate space for the entries */
     newpool->entries = (pool_ent *) mmap(0, newpool->n_entries * sizeof(pool_ent), 
                             PROT_READ | PROT_WRITE, 
-                            MAP_SHARED | MAP_ANONYMOUS, -1, 0); 
+                            MAP_SHARED | MAP_ANON, -1, 0); 
     if(!newpool->entries) {
         munmap((void *)newpool, sizeof(dead_pool));
         show_msg(MSGERR, "init_pool: unable to mmap deadpool entries "
