--- fop.sh	2003-07-15 02:04:02.000000000 +0000
+++ fop.sh.new	2007-06-14 14:22:28.000000000 +0000
@@ -11,7 +11,11 @@
 darwin=false;
 case "`uname`" in
   CYGWIN*) cygwin=true ;;
-  Darwin*) darwin=true ;;
+  Darwin*) darwin=true
+           if [ -z "$JAVA_HOME" ] ; then
+             JAVA_HOME=/Library/Java/Home
+           fi
+           ;;
 esac
 
 if [ -z "$FOP_HOME" ] ; then
