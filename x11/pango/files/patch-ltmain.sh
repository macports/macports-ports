--- ltmain.sh.orig	2005-09-11 11:11:38.000000000 -0700
+++ ltmain.sh	2005-09-11 11:12:01.000000000 -0700
@@ -1369,7 +1369,7 @@
 	continue
 	;;
 
-     -mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe)
+     -mt|-mthreads|-kthread|-Kthread|-lpthread|-lpthreads|--thread-safe)
 	deplibs="$deplibs $arg"
 	continue
 	;;
@@ -1853,7 +1853,7 @@
 	lib=
 	found=no
 	case $deplib in
-	-mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe)
+	-mt|-mthreads|-kthread|-Kthread|-lpthread|-lpthreads|--thread-safe)
 	  if test "$linkmode,$pass" = "prog,link"; then
 	    compile_deplibs="$deplib $compile_deplibs"
 	    finalize_deplibs="$deplib $finalize_deplibs"
