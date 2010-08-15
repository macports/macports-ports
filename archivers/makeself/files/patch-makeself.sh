--- makeself.sh.orig	2008-01-04 17:53:49.000000000 -0600
+++ makeself.sh	2010-08-14 21:17:27.000000000 -0500
@@ -126,7 +126,7 @@
 APPEND=n
 COPY=none
 TAR_ARGS=cvf
-HEADER=`dirname $0`/makeself-header.sh
+HEADER=@PREFIX@/libexec/makeself/makeself-header.sh
 
 # LSM file stuff
 LSM_CMD="echo No LSM. >> \"\$archname\""
