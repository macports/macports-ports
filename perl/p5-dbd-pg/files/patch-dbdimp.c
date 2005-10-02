--- work/DBD-Pg-1.43/dbdimp.c	2005-06-21 22:52:30.000000000 +0200
+++ dbdimp.c	2005-10-02 15:13:16.000000000 +0200
@@ -34,7 +34,7 @@
 #define ub2    unsigned short
 
 /* Someday, we can abandon pre-7.4 and life will be much easier... */
-#if PGLIBVERSION < 70400
+#if 0 > 1
 #define PG_DIAG_SQLSTATE 'C'
 /* Better we do all this in one place here than put more ifdefs inside dbdimp.c */
 typedef enum
