--- src/external.c.orig	2007-01-13 14:48:44.000000000 -0500
+++ src/external.c	2007-01-13 14:49:11.000000000 -0500
@@ -167,7 +167,7 @@
       rewind (fp);
       fprintf (fp, "%d", -1);
       fclose (fp);
-      truncate (pidpath->str, 2);	/* '-' '1' EOF */
+/*      truncate (pidpath->str, 2);	 '-' '1' EOF */
       g_string_free (pidpath, TRUE);
     }
 }
