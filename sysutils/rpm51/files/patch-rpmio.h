--- rpmio/rpmio.h	2007/06/17 14:49:02	1.53
+++ rpmio/rpmio.h	2007/07/10 19:46:20	1.54
@@ -664,7 +664,7 @@
  * @param prompt	prompt string
  * @return		password
  */
-char * (*Getpass) (const char * prompt)
+extern char * (*Getpass) (const char * prompt)
 	/*@*/;
 char * _GetPass (const char * prompt)
 	/*@*/;
