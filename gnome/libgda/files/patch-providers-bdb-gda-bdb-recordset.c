--- providers/bdb/gda-bdb-recordset.c	2003-12-17 12:27:02.000000000 +0100
+++ providers/bdb/gda-bdb-recordset.c	2005-07-11 15:14:57.000000000 +0200
@@ -227,6 +227,9 @@
 
 	/* get the number of records in the database */
 	ret = dbp->stat (dbp,
+#if BDB_VERSION > 40300
+			NULL,
+#endif
 			 &statp,
 #if BDB_VERSION < 40000
 			 NULL,
