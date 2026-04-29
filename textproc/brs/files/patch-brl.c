--- brl.c	1994-04-13 02:31:59.000000000 +0200
+++ brl.c	2005-12-13 22:02:33.000000000 +0100
@@ -1146,7 +1146,7 @@
     if (dfname == NULL)
 	dfname = "bible.data";
     if (dfpath == NULL)
-	dfpath = "./ /usr/local/lib/";
+	dfpath = "./ __PREFIX__/share/brs/";
     tsl_init( dfname, dfpath, memlimit );
 
     /* Set (low) illegal value for current context.
