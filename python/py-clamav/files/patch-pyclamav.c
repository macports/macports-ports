--- pyclamav.c	2005-07-09 16:01:05.000000000 +0200
+++ pyclamav.c	2005-07-18 21:13:27.000000000 +0200
@@ -128,9 +128,9 @@
  */
 int filename_is_dir(char *file)
 {
-        struct stat64 buf;
+        struct stat buf;
 
-        if(stat64(file, &buf) < 0) return(0);
+        if(stat(file, &buf) < 0) return(0);
         return(S_ISDIR(buf.st_mode));
 }
 
