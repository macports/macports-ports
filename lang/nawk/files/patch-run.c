--- run.c.orig	Tue Dec 28 23:53:45 2004
+++ run.c	Tue Dec 28 23:53:57 2004
@@ -900,7 +900,7 @@
 			break;
 		case 'f':	sprintf(p, fmt, getfval(x)); break;
 		case 'd':	sprintf(p, fmt, (long) getfval(x)); break;
-		case 'u':	sprintf(p, fmt, (int) getfval(x)); break;
+		case 'u':	sprintf(p, fmt, (unsigned int) getfval(x)); break;
 		case 's':
 			t = getsval(x);
 			n = strlen(t);
