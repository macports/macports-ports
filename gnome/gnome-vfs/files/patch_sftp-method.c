--- modules/sftp-method.c.org	Mon Apr  5 13:17:09 2004
+++ modules/sftp-method.c	Mon Apr  5 13:17:48 2004
@@ -184,7 +184,7 @@
 	buffer = buffer_in;
 
 	while (pos < size) {
-		res = TEMP_FAILURE_RETRY (f (fd, buffer, size - pos));
+		res = f (fd, buffer, size - pos);
 
 		if (res < 0)
 			return -1;
