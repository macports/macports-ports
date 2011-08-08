--- apt-inst/deb/dpkgdb.cc.orig	2011-08-08 13:14:44.000000000 +0200
+++ apt-inst/deb/dpkgdb.cc	2011-08-08 13:33:04.000000000 +0200
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <unistd.h>
