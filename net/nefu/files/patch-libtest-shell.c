--- libtest/shell.c.orig	Mon Dec 20 13:03:45 2004
+++ libtest/shell.c	Mon Dec 20 17:21:00 2004
@@ -63,17 +63,17 @@
     switch( pid ) {
     case 0:
 	/* good child -  dup2 first for perror */
-	if ( dup2( fds[ 0 ], 2 ) < 0 ) {
+	if ( dup2( fds[ 1 ], 2 ) < 0 ) {
 	    syslog( LOG_ERR, "dup2: %m" );
 	    exit( T_MAYBE_DOWN);
 	}
 
-	if ( dup2( fds[ 0 ], 1 ) < 0 ) {
+	if ( dup2( fds[ 1 ], 1 ) < 0 ) {
 	    perror( "dup2" );
 	    exit( T_MAYBE_DOWN);
 	}
 
-	if (( close( fds[ 1 ] ) < 0 ) || ( close( fds[ 0 ] ) < 0 )) {
+	if (( close( fds[ 0 ] ) < 0 ) || ( close( fds[ 1 ] ) < 0 )) {
 	    perror( "close fds" );
 	    exit( T_MAYBE_DOWN);
 	}
@@ -127,12 +127,12 @@
 	return(  T_MAYBE_DOWN );
 
     default:				/* good, parent */
-	if ( close( fds[ 0 ] ) < 0 ) {
+	if ( close( fds[ 1 ] ) < 0 ) {
 	    report_printf( r, "close: %m" );
 	    return( T_MAYBE_DOWN );
 	}
 
-	if (( n = snet_attach( fds[ 1 ], 1024 * 1024 )) == NULL ) {
+	if (( n = snet_attach( fds[ 0 ], 1024 * 1024 )) == NULL ) {
 	    report_printf( r, "snet_attach: %m" );
 	    return( T_MAYBE_DOWN );
 	}
