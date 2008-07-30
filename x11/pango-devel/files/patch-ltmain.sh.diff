--- ltmain.sh.orig	2008-01-09 03:50:47.000000000 -0600
+++ ltmain.sh	2008-01-09 03:52:08.000000000 -0600
@@ -1639,7 +1639,7 @@
 	continue
 	;;
 
-     -mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe|-threads)
+     -mt|-mthreads|-kthread|-Kthread|-lpthread|-pthreads|--thread-safe|-threads)
 	compiler_flags="$compiler_flags $arg"
 	compile_command="$compile_command $arg"
 	finalize_command="$finalize_command $arg"
@@ -2134,7 +2134,7 @@
 	lib=
 	found=no
 	case $deplib in
-	-mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe|-threads)
+	-mt|-mthreads|-kthread|-Kthread|-lpthread|-pthreads|--thread-safe|-threads)
 	  if test "$linkmode,$pass" = "prog,link"; then
 	    compile_deplibs="$deplib $compile_deplibs"
 	    finalize_deplibs="$deplib $finalize_deplibs"
