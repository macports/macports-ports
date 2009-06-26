--- binutils/dwarf.c.orig	2009-06-26 12:46:14.000000000 -0700
+++ binutils/dwarf.c	2009-06-26 12:46:27.000000000 -0700
@@ -186,7 +186,7 @@
   snprintf (buff, sizeof (buff), "%16.16lx ", val);
 #endif
 
-  printf (buff + (byte_size == 4 ? 8 : 0));
+  printf ("%s", buff + (byte_size == 4 ? 8 : 0));
 }
 
 static unsigned long int
