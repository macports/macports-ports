--- gcc/gcc.c	2004-07-12 23:00:35.000000000 +0200
+++ gcc/gcc.c	2007-07-25 12:43:01.000000000 +0200
@@ -5880,7 +5880,7 @@
 		  if (q == vt || *q != ')')
 		    abort ();
 		  v = xstrdup (vt);
-		  v[q - vt] = 0;
+		  (char) v[q - vt] = 0;
 		}
 	      /* APPLE LOCAL end Apple version */
 
