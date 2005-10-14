--- ltmain.sh.orig	2005-09-14 11:00:12.000000000 -0400
+++ ltmain.sh	2005-10-14 19:07:04.000000000 -0400
@@ -1518,7 +1518,7 @@
 	continue
 	;;
 
-     -mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe)
+     -mt|-mthreads|-kthread|-Kthread|-lpthread|-lpthreads|--thread-safe)
 	compiler_flags="$compiler_flags $arg"
 	compile_command="$compile_command $arg"
 	finalize_command="$finalize_command $arg"
@@ -2005,7 +2005,7 @@
 	lib=
 	found=no
 	case $deplib in
-	-mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe)
+	-mt|-mthreads|-kthread|-Kthread|-lpthread|-lpthreads|--thread-safe)
 	  if test "$linkmode,$pass" = "prog,link"; then
 	    compile_deplibs="$deplib $compile_deplibs"
 	    finalize_deplibs="$deplib $finalize_deplibs"
