===================================================================
RCS file: /usr/local/src/cvsroot/nefu/libtest/tcp.c,v
retrieving revision 1.11
retrieving revision 1.12
diff -u -r1.11 -r1.12
--- libtest/tcp.c	2003/09/22 21:20:00	1.11
+++ libtest/tcp.c	2003/11/19 16:01:13	1.12
@@ -180,6 +180,25 @@
 	goto done2;
     }
 
+    if ( snet_writef( n, "HELO %s\r\n", nefu_localdomain ) < 0 ) {
+	report_printf( r, "%m" );
+	result = T_MAYBE_DOWN;
+	goto done2;
+    }
+
+    tv.tv_sec = TIME;
+    tv.tv_usec = 0;
+    if (( p = stcp_reply( n, &tv )) == NULL ) {
+	report_printf( r, "%m" );
+	result = T_MAYBE_DOWN;
+	goto done2;
+    }
+    if ( *p != '2' ) {
+	report_printf( r, "%s", p );
+	result = T_MAYBE_DOWN;
+	goto done2;
+    }
+
     if ( snet_writef( n, "MAIL FROM:<%s@%s>\r\n", nefu_uname,
 	    nefu_localdomain ) < 0 ) {
 	report_printf( r, "%m" );
