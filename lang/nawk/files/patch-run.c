--- run.c.orig	2018-08-28 15:05:48.000000000 -0500
+++ run.c	2018-10-11 06:24:36.000000000 -0500
@@ -930,7 +930,7 @@
 		case 'A':
 		case 'f':	sprintf(p, fmt, getfval(x)); break;
 		case 'd':	sprintf(p, fmt, (long) getfval(x)); break;
-		case 'u':	sprintf(p, fmt, (int) getfval(x)); break;
+		case 'u':	sprintf(p, fmt, (unsigned int) getfval(x)); break;
 		case 's':
 			t = getsval(x);
 			n = strlen(t);
