--- src/proto.h.orig	Thu Jul  3 17:00:18 2003
+++ src/proto.h	Thu Oct 30 20:08:51 2003
@@ -94,7 +94,9 @@
 char *PushString(struct Push *, const char *);
 char *PushNString(struct Push *, const char *, int);
 
+#ifndef HAVE_STRCASESTR
 char *strcasestr (char *, const char *);
+#endif
 char *strsav(const char *);
 char *strreplace(char *, char *);
 void strcpymax(char *, const char *, int);
