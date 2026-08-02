--- findsaddr-socket.c.orig	2009-08-13 00:07:52.000000000 -0700
+++ findsaddr-socket.c	2009-08-13 00:08:08.000000000 -0700
@@ -189,7 +189,7 @@
 				break;
 
 			default:
-				/* empty */
+				break;
 			}
 
 			if (SALEN(sa) == 0)
