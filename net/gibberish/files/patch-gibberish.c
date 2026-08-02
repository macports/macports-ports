--- gibberish.c	Sat Sep  6 22:11:37 2003
+++ gibberish.c.new	Sat Sep 18 17:02:34 2004
@@ -295,7 +295,7 @@
 
 	if (argc != 5)
 	{
-		printf("Usage: %s -t/-u -a/-b hostname portnr\n", argv[0]);
+		printf("Usage: %s (-t|-u) (-a|-b) hostname portnr\n", argv[0]);
 		return 1;
 	}
 
