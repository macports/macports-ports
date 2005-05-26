--- src/lib/libast/sfio/sfhdr.h.orig	2005-05-25 20:32:14.000000000 -0400
+++ src/lib/libast/sfio/sfhdr.h	2005-05-25 20:32:16.000000000 -0400
@@ -1121,7 +1121,6 @@
 extern int		_sfsetpool _ARG_((Sfio_t*));
 extern char*		_sfcvt _ARG_((Sfdouble_t,char*,size_t,int,int*,int*,int*,int));
 extern char**		_sfgetpath _ARG_((char*));
-extern Sfdouble_t	_sfdscan _ARG_((Void_t*, int(*)(Void_t*,int)));
 
 #if _BLD_sfio && defined(__EXPORT__)
 #define extern		__EXPORT__
