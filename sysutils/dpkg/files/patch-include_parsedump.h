--- include/parsedump.h	2002-05-06 12:18:16.000000000 -0400
+++ include/parsedump.h	2005-06-09 20:47:46.000000000 -0400
@@ -30,7 +30,6 @@
   const char *canon;
 };
 
-extern const struct fieldinfo fieldinfos[];
 extern const struct nickname nicknames[];
 extern const int nfields; /* = elements in fieldinfos, including the sentinels */
 
@@ -68,6 +67,8 @@
   unsigned int integer;
 };
 
+extern const struct fieldinfo fieldinfos[];
+
 void parseerr(FILE *file, const char *filename, int lno, FILE *warnto, int *warncount,
               const struct pkginfo *pigp, int warnonly,
               const char *fmt, ...) PRINTFFORMAT(8,9);
