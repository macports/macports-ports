2005-05-15  Dmitry V. Levin <ldv@altlinux.org>

	* src/names.c (contains_dot_dot): Fix ".." detection.
	Previous edition fails to recognize "foo//.." case.

--- src/names.c.orig	2004-09-06 11:30:54 +0000
+++ src/names.c	2005-05-15 13:21:13 +0000
@@ -1152,11 +1152,10 @@ contains_dot_dot (char const *name)
       if (p[0] == '.' && p[1] == '.' && (ISSLASH (p[2]) || !p[2]))
 	return 1;
 
-      do
+      while (! ISSLASH (*p))
 	{
 	  if (! *p++)
 	    return 0;
 	}
-      while (! ISSLASH (*p));
     }
 }
