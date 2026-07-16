--- sel_file.c.orig	2007-07-10 06:18:01.000000000 -0500
+++ sel_file.c	2009-09-10 02:25:51.000000000 -0500
@@ -16,9 +16,6 @@
 #include  <sys/stat.h>
 #include  <unistd.h>
 #include  <string.h>
-/* nasty hack */
-char *strdup(char *);
-/* end of hack */
 #include  <ctype.h>
 #include  <dirent.h>
 
