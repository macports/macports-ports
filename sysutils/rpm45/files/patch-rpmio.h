--- rpmio/rpmio.h	2007-05-25 12:00:39.000000000 -0700
+++ rpmio/rpmio.h	2007-06-13 10:52:54.000000000 -0700
@@ -664,7 +664,11 @@
  * @param prompt	prompt string
  * @return		password
  */
+#ifdef NO_EXTERN
 char * (*Getpass) (const char * prompt)
+#else
+extern char * (*Getpass) (const char * prompt)
+#endif
 	/*@*/;
 char * _GetPass (const char * prompt)
 	/*@*/;

