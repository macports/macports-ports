--- odbcinst/SQLManageDataSources.c.orig	Mon Feb 10 09:59:46 2003
+++ odbcinst/SQLManageDataSources.c	Sat Mar  1 14:25:28 2003
@@ -89,12 +89,19 @@
                  */
 
 #ifdef SHLIBEXT
-                if ( strlen( SHLIBEXT ) > 0 )
-                    sprintf( szGUILibFile, "libodbcinstQ%s.1", SHLIBEXT );
-                else
-                    sprintf( szGUILibFile, "libodbcinstQ.so.1" );
+#if defined(__APPLE__) && defined(__GNUC__) //Darwin
+       if ( strlen( SHLIBEXT ) > 0 )
+            sprintf( szGUILibFile, "%s/libodbcinstQ.1.%s", DEFLIB_PATH, SHLIBEXT );
+        else
+            sprintf( szGUILibFile, "%s/libodbcinstQ.1.so", DEFLIB_PATH);
+#else //Darwin
+         if ( strlen( SHLIBEXT ) > 0 )
+             sprintf( szGUILibFile, "libodbcinstQ%s.1", SHLIBEXT );
+         else
+             sprintf( szGUILibFile, "libodbcinstQ.so.1" );
+#endif //Darwin
 #else
-                sprintf( szGUILibFile, "libodbcinstQ.so.1" );
+         sprintf( szGUILibFile, "libodbcinstQ.so.1" );
 #endif        
 
                 if ( lt_dladdsearchdir( DEFLIB_PATH ) )
