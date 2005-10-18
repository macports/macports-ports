--- rmd160.h	1999-07-31 15:39:31.000000000 +0200
+++ rmd160.h	2005-10-18 10:34:20.000000000 +0200
@@ -31,7 +31,7 @@
 
 __BEGIN_DECLS
 void   RMD160Init(RMD160_CTX *);
-void   RMD160Update(RMD160_CTX *, const unsigned char *, unsigned int);
+void   RMD160Update(RMD160_CTX *, const unsigned char *, size_t);
 void   RMD160Final(unsigned char [RMD160_HASHBYTES], RMD160_CTX *);
 char * RMD160End(RMD160_CTX *, char *);
 char * RMD160File(const char *, char *);
