--- scripts/doc-build.sh.orig	2011-09-17 23:00:44.000000000 +0200
+++ scripts/doc-build.sh	2011-09-17 23:01:06.000000000 +0200
@@ -12,7 +12,7 @@
 dest=$2
 name=$(basename ${src%.*})
 date=$(date -u +'%Y-%M-%d %H:%m:%S')
-version=$(npm -v)
+version=@@_VERSION_@@
 
 mkdir -p $(dirname $dest)
 
