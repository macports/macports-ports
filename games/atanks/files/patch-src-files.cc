--- src/files.cc.orig	2008-07-26 12:05:50.000000000 -0600
+++ src/files.cc	2008-08-10 18:47:46.000000000 -0600
@@ -2,6 +2,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <dirent.h>
+#include <sys/stat.h>
 
 #include "player.h"
 #include "files.h"
@@ -698,7 +699,7 @@
 /*
 Filter out files that do not have .sav in the name.
 */
-int Filter_File( const struct dirent *my_file )
+int Filter_File( struct dirent *my_file )
 {
     if ( strstr(my_file->d_name, ".sav") )
        return TRUE;
