--- tracer/trcutil.c	1999-03-22 16:25:58.000000000 +0100
+++ tracer/trcutil.c	2006-08-18 10:29:30.000000000 +0200
@@ -2888,7 +2888,7 @@
 
 	time( &t );
 
-	sprintf( tmp, "%s", ctime( &t ) );
+	ctime_r( &t, tmp );
 
 	result = tmp;
 
