--- jargrep.c.orig	2005-04-03 23:17:36.000000000 -0400
+++ jargrep.c	2005-04-03 23:18:41.000000000 -0400
@@ -571,8 +571,6 @@
 				case 1:
 					floop = FALSE;
 					break;
-				case 2:
-					/* fall through continue */
 				}
 			}
 		} while(floop);
