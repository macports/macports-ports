--- daapd.cc.orig	Mon Jan  3 22:00:06 2005
+++ daapd.cc	Mon Jan  3 22:00:17 2005
@@ -829,7 +829,7 @@
 		}
 	}
 	
-	conf = fopen( "/etc/daapd.conf", "r" );
+	conf = fopen( "@PREFIX@/etc/daapd.conf", "r" );
 	if( conf != NULL ) {
 		return( parseConfig( conf, initParams ) );
 	}
