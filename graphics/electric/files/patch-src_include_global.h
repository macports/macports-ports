--- src/include/global.h.orig	2004-07-15 19:59:53.000000000 -0600
+++ src/include/global.h	2005-10-01 16:53:05.000000000 -0600
@@ -2169,7 +2169,7 @@
 INTBIG       parse(CHAR *keyword, COMCOMP *list, BOOLEAN noise);
 void        *initinfstr(void);
 void         addtoinfstr(void*, CHAR c);
-void         addstringtoinfstr(void*, CHAR *str);
+void         addstringtoinfstr(void*, const CHAR *str);
 void         formatinfstr(void*, CHAR *msg, ...);
 CHAR        *returninfstr(void*);
 void        *newstringarray(CLUSTER *cluster);
