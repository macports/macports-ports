--- apr-util/build/apu-conf.m4	Mon Nov 18 21:37:06 2002
+++ apr-util/build/apu-conf.m4	Mon Nov 18 21:37:37 2002
@@ -499,7 +499,7 @@
     expat_libs="-lexpat"
     expat_libtool="$1/lib64/libexpat.la"
   elif test -r "$1/include/expat.h" -a \
-    -r "$1/lib/libexpat.a"; then
+    -r "$1/lib/libexpat.0.dylib"; then
     dnl Expat 1.95.* installation (without libtool)
     dnl FreeBSD textproc/expat2
     expat_include_dir="$1/include"
