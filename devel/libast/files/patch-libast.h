--- include/libast.h.org	Wed Dec 15 08:03:17 2004
+++ include/libast.h	Wed Dec 15 08:03:41 2004
@@ -2735,9 +2735,7 @@
 #if !(HAVE_MEMMEM)
 extern void *memmem(const void *, size_t, const void *, size_t);
 #endif
-#if !(HAVE_STRNLEN)
 extern size_t strnlen(const char *, size_t);
-#endif
 #if !(HAVE_USLEEP)
 extern void usleep(unsigned long);
 #endif
@@ -2754,9 +2752,7 @@
 #if !(HAVE_STRCASEPBRK)
 extern char *strcasepbrk(const char *, const char *);
 #endif
-#if !(HAVE_STRREV)
 extern char *strrev(char *);
-#endif
 #if !(HAVE_STRSEP)
 extern char *strsep(char **, char *);
 #endif
