--- src/strings.c.org	Wed Jun  9 16:37:53 2004
+++ src/strings.c	Wed Jun  9 16:38:07 2004
@@ -49,7 +49,6 @@
 }
 #endif
 
-#ifndef HAVE_STRNLEN
 size_t
 strnlen(register const char *s, size_t maxlen)
 {
@@ -60,7 +59,6 @@
     for (n = 0; *s && n < maxlen; s++, n++);
     return n;
 }
-#endif
 
 #ifndef HAVE_USLEEP
 void
@@ -549,7 +547,6 @@
 }
 #endif
 
-#ifndef HAVE_STRREV
 char *
 strrev(register char *str)
 {
@@ -562,7 +559,6 @@
     return (str);
 
 }
-#endif
 
 #if !(HAVE_STRSEP)
 char *
