--- src/strings.c.org	Wed Dec 15 10:01:19 2004
+++ src/strings.c	Wed Dec 15 10:01:44 2004
@@ -63,7 +63,6 @@
 }
 #endif
 
-#if !(HAVE_STRNLEN)
 size_t
 strnlen(register const char *s, size_t maxlen)
 {
@@ -73,7 +72,6 @@
     for (n = 0; *s && n < maxlen; s++, n++);
     return n;
 }
-#endif
 
 #if !(HAVE_USLEEP)
 void
@@ -150,7 +148,6 @@
 }
 #endif
 
-#if !(HAVE_STRREV)
 char *
 strrev(register char *str)
 {
@@ -164,7 +161,6 @@
     return (str);
 
 }
-#endif
 
 #if !(HAVE_STRSEP)
 char *
