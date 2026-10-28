--- io.c.orig	2002-05-08 15:39:10.000000000 -0500
+++ io.c	2014-04-20 14:21:54.000000000 -0500
@@ -24,7 +24,7 @@
  *	FILE INPUT ROUTINES
  *
  *	long lgetc()				read one character from input buffer
- *	long lrint()				read one integer from input buffer
+ *	long lrint_x()				read one integer from input buffer
  *	lrfill(address,number)		put input bytes into a buffer
  *	char *lgetw()				get a whitespace ended word from input
  *	char *lgetl()				get a \n or EOF ended line from input
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
@@ -345,7 +344,7 @@
     }
 
 /*
- *	long lrint()			Read one integer from input buffer
+ *	long lrint_x()			Read one integer from input buffer
  *
  *		+---------+---------+---------+---------+
  *		|	high  |			|		  |	  low	|
@@ -357,7 +356,7 @@
  *	The save order is low order first, to high order (4 bytes total)
  *	Returns the int read
  */
-long lrint()
+long lrint_x()
 	{
 	unsigned long i;
 	i  = 255 & lgetc();				i |= (255 & lgetc()) << 8;
@@ -454,7 +453,7 @@
 	if (str==NULL) return(lfd=1);
 	if ((lfd=creat(str,0644)) < 0)
 		{
-		lfd=1; lprintf("error creating file <%s>\n",str); lflush(); return(-1);
+		lfd=1; lprintf(2,"error creating file <%s>\n",str); lflush(); return(-1);
 		}
 	return(lfd);
 	}
