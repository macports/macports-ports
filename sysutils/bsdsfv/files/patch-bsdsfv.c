--- bsdsfv.c.orig	2010-01-21 03:31:58.000000000 -0800
+++ bsdsfv.c	2010-01-21 03:35:39.000000000 -0800
@@ -43,7 +43,7 @@
 
 typedef struct sfvtable {
 	char filename[FNAMELEN];
-	int crc;
+	unsigned int crc;
 	int found;
 } SFVTABLE;
 
