--- ../db185/db185.c.orig	Sat Mar  6 07:56:06 2004
+++ ../db185/db185.c	Sat Mar  6 08:04:20 2004
@@ -40,8 +40,13 @@
 
 /*
  * EXTERN: #define dbopen __db185_open
+ * EXTERN: #ifdef _DB185_INT_H_
  * EXTERN: DB185 *__db185_open
  * EXTERN:     __P((const char *, int, int, DBTYPE, const void *));
+ * EXTERN: #else
+ * EXTERN: DB *__db185_open
+ * EXTERN:     __P((const char *, int, int, DBTYPE, const void *));
+ * EXTERN: #endif
  */
 DB185 *
 __db185_open(file, oflags, mode, type, openinfo)
