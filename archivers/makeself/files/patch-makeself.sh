diff -rwub makeself.orig/makeself.sh makeself/makeself.sh
--- makeself.sh	Wed Oct 20 20:15:41 2004
+++ makeself.sh	Wed Oct 20 20:16:30 2004
@@ -106,7 +106,7 @@
 APPEND=n
 COPY=none
 TAR_ARGS=cvf
-HEADER=`dirname $0`/makeself-header.sh
+HEADER=@PREFIX@/libexec/makeself/makeself-header.sh
 
 # LSM file stuff
 LSM_CMD="echo No LSM. >> \"\$archname\""
