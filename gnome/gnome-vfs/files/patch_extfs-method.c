--- modules/extfs-method.c.org	Sun Nov 23 16:36:59 2003
+++ modules/extfs-method.c	Sun Nov 23 16:37:38 2003
@@ -49,9 +49,6 @@
 #include <unistd.h>
 #include <stdlib.h>
 
-#ifndef HAVE_GETDELIM
-
-
 /* Read up to (and including) a TERMINATOR from STREAM into *LINEPTR
    (and null-terminate it). *LINEPTR is a pointer returned from malloc (or
    NULL), pointing to *N characters of space.  It is realloc'd as
@@ -131,7 +128,6 @@
 	}
 
 
-#endif
 
 #define EXTFS_COMMAND_DIR	LIBDIR "/vfs/2.0/extfs"
 
