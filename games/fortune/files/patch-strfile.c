--- strfile/strfile.c.orig	Tue Oct  8 17:16:57 2002
+++ strfile/strfile.c	Tue Oct  8 17:17:05 2002
@@ -452,7 +452,7 @@
 	long   tmp;
 	long   *sp;
 
-	srandomdev();
+	srandom(getpid());
 
 	Tbl.str_flags |= STR_RANDOM;
 	cnt = Tbl.str_numstr;
