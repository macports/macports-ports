--- include/libast.h.org	Wed Jun  9 16:33:23 2004
+++ include/libast.h	Wed Jun  9 16:36:50 2004
@@ -673,9 +673,7 @@
 #ifndef HAVE_STRCASEPBRK
 extern char *strcasepbrk(const char *, const char *);
 #endif
-#ifndef HAVE_STRREV
 extern char *strrev(char *);
-#endif
 #if !(HAVE_STRSEP)
 extern char *strsep(char **, char *);
 #endif
@@ -688,9 +686,7 @@
 #ifndef HAVE_MEMMEM
 extern void *memmem(const void *, size_t, const void *, size_t);
 #endif
-#ifndef HAVE_STRNLEN
 extern size_t strnlen(const char *, size_t);
-#endif
 #ifndef HAVE_USLEEP
 extern void usleep(unsigned long);
 #endif
