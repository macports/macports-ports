--- src/conn.c	Sun Feb 13 09:22:10 2000
+++ src/conn.c	Thu Jan  4 16:07:36 2001
@@ -232,7 +232,12 @@
 					*(p++)=' ';
 					continue;
 				};
-			};
+			} else {
+			    /* emk - 04 Jan 2001 - Bug fix to leave buffer
+			    ** pointing at start of body after reading blank
+			    ** line following header. */
+			    p=t;
+			}
 
 			c->bufferpos+=p+1-*z;
