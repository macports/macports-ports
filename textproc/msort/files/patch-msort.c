--- msort.c	2005-10-29 04:29:48.000000000 +0200
+++ msort.c	2005-10-29 18:01:52.000000000 +0200
@@ -1259,8 +1259,6 @@
   extern int GetTimeKey(wchar_t *, double *);
   extern int GetDateKey(wchar_t *, double *,struct ymdinfo *);
   extern wchar_t *wcCopyRange(wchar_t *, long, long);
-  extern int fwprintf (__FILE *__restrict __stream,
-		       __const wchar_t *__restrict __format, ...);
 
 
   InitializeDynamicString(&TempKey);
