--- makeself.sh.orig	2013-04-12 19:09:57.000000000 -0500
+++ makeself.sh	2013-08-15 05:16:12.000000000 -0500
@@ -143,7 +143,7 @@
 TAR_ARGS=cvf
 TAR_EXTRA=""
 DU_ARGS=-ks
-HEADER=`dirname "$0"`/makeself-header.sh
+HEADER=@PREFIX@/libexec/makeself/makeself-header.sh
 TARGETDIR=""
 
 # LSM file stuff
