--- gcc/java/gjavah.c	2006-11-05 09:01:19.000000000 +0900
+++ gcc/java/gjavah.c	2006-11-05 09:01:01.000000000 +0900
@@ -46,7 +46,7 @@
 static int found_error = 0;
 
 /* Nonzero if we're generating JNI output.  */
-static int flag_jni = 0;
+int flag_jni = 0;
 
 /* When nonzero, warn when source file is newer than matching class
    file.  */
