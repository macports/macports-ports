--- src/support.c.org	Thu Jan  6 14:52:31 2005
+++ src/support.c	Thu Jan  6 14:52:55 2005
@@ -33,7 +33,6 @@
 				 */
 extern void outofmemory();
 
-#if !defined( HAVE_STRTOKEN )
 /*
  * *  strtoken.c --   walk through a string of tokens, using a set
  * of separators 
@@ -69,7 +68,6 @@
     *save = pos;
     return (tmp);
 }
-#endif /* !HAVE_STRTOKEN */
 
 #if !defined( HAVE_STRTOK )
 /* NOT encouraged to use! */
