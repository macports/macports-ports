--- ./Packages/RNG/Src/ranf.c.orig	2005-04-03 14:23:06.000000000 +0200
+++ ./Packages/RNG/Src/ranf.c	2007-10-31 12:59:50.000000000 +0100
@@ -149,7 +149,7 @@ void Mixranf(int *s,u32 s48[2])
 #else
 	struct timeval tv;
 	struct timezone tz;
-#if !defined(__sgi)
+#if !defined(__sgi) && !defined(__APPLE__)
 	int gettimeofday(struct timeval *, struct timezone *);
 #endif
 
