--- io.c.orig	2006-04-17 04:21:08.000000000 -0400
+++ io.c	2006-04-17 22:33:36.000000000 -0400
@@ -81,7 +81,7 @@
 #endif /* not SYSV */
 
 #ifndef NOVARARGS	/* if we have varargs */
-#include <varargs.h>
+#include <stdarg.h>
 #else /* NOVARARGS *//* if we don't have varargs */
 typedef char *va_list;
 #define va_dcl int va_alist;
@@ -158,7 +158,7 @@
 	{
 	long *p,*pe;
 	for (p=c,pe=c+100; p<pe; *p++ =0);
-	time(&initialtime);             srandomdev();
+	time(&initialtime);             srandom(getpid());
 	lcreat((char*)0);	/* open buffering for output to terminal */
 	}
 
@@ -194,8 +194,7 @@
 	}
 #else /* lint */
 /*VARARGS*/
-lprintf(va_alist)
-va_dcl
+void lprintf(int va_alist,...)
     {
 	va_list ap;	/* pointer for variable argument list */
 	char *fmt;
@@ -203,7 +202,7 @@
 	long wide,left,cont,n;		/* data for lprintf	*/
 	char db[12];			/* %d buffer in lprintf	*/
 
-	va_start(ap);	/* initialize the var args pointer */
+    va_start(ap, va_alist); /* initialize the var args pointer */
 	fmt = va_arg(ap, char *);	/* pointer to format string */
 	if (lpnt >= lpend) lflush();
 	outb = lpnt;
@@ -454,7 +453,7 @@
 	if (str==NULL) return(lfd=1);
 	if ((lfd=creat(str,0644)) < 0)
 		{
-		lfd=1; lprintf("error creating file <%s>\n",str); lflush(); return(-1);
+		lfd=1; lprintf(2,"error creating file <%s>\n",str); lflush(); return(-1);
 		}
 	return(lfd);
 	}
