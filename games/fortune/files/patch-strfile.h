--- strfile/strfile.h.orig	2007-11-17 23:09:17.000000000 -0700
+++ strfile/strfile.h	2007-11-17 23:10:41.000000000 -0700
@@ -36,10 +36,11 @@
  *	@(#)strfile.h	8.1 (Berkeley) 5/31/93
  */
 /* $FreeBSD: src/games/fortune/strfile/strfile.h,v 1.4 2005/02/17 18:06:37 ru Exp $ */
 
 #include <sys/types.h>
+#include <stdint.h>
 
 #define	STR_ENDSTRING(line,tbl) \
 	(((unsigned char)(line)[0]) == (tbl).str_delim && (line)[1] == '\n')
 
 typedef struct {				/* information table */
