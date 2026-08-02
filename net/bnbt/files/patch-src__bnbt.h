--- src/bnbt.h.orig	2005-04-03 07:32:44.000000000 -0400
+++ src/bnbt.h	2005-04-03 07:33:11.000000000 -0400
@@ -142,7 +142,6 @@
 extern char *GetLastErrorString( );
 
 #ifdef __APPLE__
- typedef int socklen_t;
  typedef int sockopt_len_t;
 #endif
 
