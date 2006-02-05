--- msort.c	2006-02-04 21:52:58.000000000 +0100
+++ msort.c	2006-02-05 11:05:25.000000000 +0100
@@ -1330,8 +1330,6 @@
   extern int GetTimeKey(wchar_t *, DOUBLE *);
   extern int GetDateKey(wchar_t *, DOUBLE *,struct ymdinfo *);
   extern wchar_t *wcCopyRange(wchar_t *, long, long);
-  extern int fwprintf (__FILE *__restrict __stream,
-		       __const wchar_t *__restrict __format, ...);
 
 
   InitializeDynamicString(&TempKey);
