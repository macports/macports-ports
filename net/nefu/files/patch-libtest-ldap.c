===================================================================
RCS file: /usr/local/src/cvsroot/nefu/libtest/ldap.c,v
retrieving revision 1.7
retrieving revision 1.8
diff -u -r1.7 -r1.8
--- libtest/ldap.c	2002/05/23 02:07:18	1.7
+++ libtest/ldap.c	2003/11/20 18:34:51	1.8
@@ -1,6 +1,7 @@
 /**********          ldap.c          ***********/
 
 #include <sys/types.h>
+#include <sys/time.h>
 #include <netinet/in.h>
 
 #include <stdio.h>
@@ -24,6 +25,7 @@
     int                         rc;
     struct timeval              tv;
     int				port;
+    int				ldap_err;
 
     tv.tv_sec = DEFAULT_TIMEOUT;
     tv.tv_usec = 0;
@@ -36,7 +38,8 @@
     }
 
     if (( msgid = ldap_simple_bind( ld, NULL, NULL )) < 0 ) {
-        report_printf( r, "%s", ldap_err2string( ld->ld_errno ));
+        ldap_get_option( ld, LDAP_OPT_ERROR_NUMBER, &ldap_err);
+        report_printf( r, "%s", ldap_err2string( ldap_err ));
         ldap_unbind( ld );      /* don't need to check return */
         return( T_MAYBE_DOWN );
     }
@@ -53,19 +56,22 @@
 
     case -1:
     default:
-        report_printf( r, "%s", ldap_err2string( ld->ld_errno ));
+        ldap_get_option( ld, LDAP_OPT_ERROR_NUMBER, &ldap_err);
+        report_printf( r, "%s", ldap_err2string( ldap_err ));
         ldap_unbind( ld );      /* don't need to check return */
         return( T_MAYBE_DOWN );
     }
 
     if ( ldap_msgfree( result ) != LDAP_RES_BIND ) {
-        report_printf( r, "%s", ldap_err2string( ld->ld_errno ));
+        ldap_get_option( ld, LDAP_OPT_ERROR_NUMBER, &ldap_err);
+        report_printf( r, "%s", ldap_err2string( ldap_err ));
         ldap_unbind( ld );      /* don't need to check return */
         return( T_MAYBE_DOWN );
     }
 
     if ( ldap_unbind( ld ) < 0 ) {
-        report_printf( r, "%s", ldap_err2string( ld->ld_errno ));
+        ldap_get_option( ld, LDAP_OPT_ERROR_NUMBER, &ldap_err);
+        report_printf( r, "%s", ldap_err2string( ldap_err ));
         return( T_MAYBE_DOWN );
     }
 
