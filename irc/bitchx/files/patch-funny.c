--- source/funny.c	2003-02-20 16:37:07.000000000 +0000
+++ source/funny.c	2003-02-20 16:39:13.000000000 +0000
@@ -261,6 +261,11 @@
 	channel = Args[1];
 	line = Args[2];
 
+	if (channel == NULL || line == NULL) { 
+		bitchsay("Invalid number of arguments for %s", __FUNCTION__); 
+		return; 
+	} 
+
 	ptr = line;
 	while (*ptr)
 	{
