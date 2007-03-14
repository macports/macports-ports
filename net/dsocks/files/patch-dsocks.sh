--- dsocks.sh	2006-10-12 04:13:58.000000000 +0000
+++ dsocks.sh.darwin	2007-02-14 13:11:57.000000000 +0000
@@ -8,8 +8,5 @@
 #export LOCALDOMAIN="int.example.com"
 
 # for MacOS X...
-#LIBDSOCKS=/usr/local/lib/libdsocks.dylib
-#DYLD_INSERT_LIBRARIES=$LIBDSOCKS DYLD_FORCE_FLAT_NAMESPACE=1 exec "$@"
-
-LIBDSOCKS=/usr/local/lib/libdsocks.so.1.0
-LD_PRELOAD=$LIBDSOCKS exec "$@"
+LIBDSOCKS=/usr/local/lib/libdsocks.dylib
+DYLD_INSERT_LIBRARIES=$LIBDSOCKS DYLD_FORCE_FLAT_NAMESPACE=1 exec "$@"
