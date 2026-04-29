--- src/proto.h.orig	2009-10-20 18:54:26.000000000 +0200
+++ src/proto.h	2009-12-08 07:26:46.000000000 +0100
@@ -104,7 +104,9 @@
 char *PushString(struct Push *, const char *);
 char *PushNString(struct Push *, const char *, int);
 
+#ifndef HAVE_STRCASESTR
 char *strcasestr (const char *, const char *);
+#endif
 char *strsav(const char *);
 char *strreplace(char *, char *);
 void strcpymax(char *, const char *, int);
