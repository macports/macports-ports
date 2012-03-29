--- ldapvi.c.orig	2012-03-29 17:00:13.000000000 -0400
+++ ldapvi.c	2012-03-29 17:00:50.000000000 -0400
@@ -1465,7 +1465,7 @@
 	int line = 0;
 	int c;
 
-	if (lstat(sasl, &st) == -1) return;
+	if (lstat(sasl, &st) == -1) return 0;
 	if ( !(in = fopen(sasl, "r"))) syserr();
 
 	if (st.st_size > 0) {
