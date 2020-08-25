diff --git src/builtin.c src/builtin.c
--- src/builtin.c
+++ src/builtin.c
@@ -1,5 +1,6 @@
 #define _BSD_SOURCE
 #define _GNU_SOURCE
+#define _REENTRANT
 #ifndef __sun__
 # define _XOPEN_SOURCE
 # define _XOPEN_SOURCE_EXTENDED 1
