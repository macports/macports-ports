--- src/system.h.orig	2002-04-05 13:37:31.000000000 -0700
+++ src/system.h	2006-02-16 00:31:46.000000000 -0700
@@ -397,5 +397,6 @@
     && (s)->st_gid == (t)->st_gid \
     && (s)->st_size == (t)->st_size \
     && (s)->st_mtime == (t)->st_mtime \
+    && (s)->st_mtimespec.tv_nsec == (t)->st_mtimespec.tv_nsec \
     && (s)->st_ctime == (t)->st_ctime)
 #endif
