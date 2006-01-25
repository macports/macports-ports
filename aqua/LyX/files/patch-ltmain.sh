--- config/ltmain.sh.orig	2006-01-02 21:12:45.000000000 +0100
+++ config/ltmain.sh	2006-01-02 21:12:50.000000000 +0100
@@ -1230,6 +1230,19 @@
 	  prev=
 	  continue
 	  ;;
+	framework)
+	  case $host in
+	    *-*-darwin*)
+	      case "$deplibs " in
+	        *" $qarg.ltframework "*) ;;
+		*) deplibs="$deplibs $qarg.ltframework" # this is fixed later
+		   ;;
+              esac
+              ;;
+   	  esac
+	  prev=
+	  continue
+	  ;;
 	*)
 	  eval "$prev=\"\$arg\""
 	  prev=
@@ -1354,7 +1367,7 @@
 	    ;;
 	  *-*-rhapsody* | *-*-darwin1.[012])
 	    # Rhapsody C and math libraries are in the System framework
-	    deplibs="$deplibs -framework System"
+	    deplibs="$deplibs System.ltframework"
 	    continue
 	  esac
 	elif test "X$arg" = "X-lc_r"; then
@@ -1551,6 +1564,11 @@
 	continue
 	;;
 
+      -framework)
+        prev=framework
+	continue
+	;;
+
       # Some other compiler flag.
       -* | +*)
 	# Unknown arguments in both finalize_command and compile_command need
@@ -1934,6 +1952,18 @@
 	    fi
 	  fi
 	  ;; # -l
+	*.ltframework)
+	  if test "$linkmode,$pass" = "prog,link"; then
+	    compile_deplibs="$deplib $compile_deplibs"
+	    finalize_deplibs="$deplib $finalize_deplibs"
+	  else
+	    deplibs="$deplib $deplibs"
+	    if test "$linkmode" = lib ; then
+	      newdependency_libs="$deplib $newdependency_libs"
+	    fi
+	  fi
+	  continue
+	  ;;
 	-L*)
 	  case $linkmode in
 	  lib)
@@ -2062,6 +2092,13 @@
 	*) . ./$lib ;;
 	esac
 
+	case $host in
+	*-*-darwin*)
+	  # Convert "-framework foo" to "foo.ltframework" in dependency_libs
+	  test -n "$dependency_libs" && dependency_libs=`$echo "X$dependency_libs" | $Xsed -e 's/-framework \([^ $]*\)/\1.ltframework/g'`
+	  ;;
+	esac
+
 	if test "$linkmode,$pass" = "lib,link" ||
 	   test "$linkmode,$pass" = "prog,scan" ||
 	   { test "$linkmode" != prog && test "$linkmode" != lib; }; then
@@ -2671,6 +2708,15 @@
 		*) continue ;;
 		esac
 		;;
+
+	      *.ltframework)
+		case $host in
+		  *-*-darwin*)
+		    depdepl="$deplib"
+		    ;;
+		esac
+		;;
+
 	      *) continue ;;
 	      esac
 	      case " $deplibs " in
@@ -3191,7 +3237,7 @@
 	    ;;
 	  *-*-rhapsody* | *-*-darwin1.[012])
 	    # Rhapsody C library is in the System framework
-	    deplibs="$deplibs -framework System"
+	    deplibs="$deplibs System.ltframework"
 	    ;;
 	  *-*-netbsd*)
 	    # Don't link with libc until the a.out ld.so is fixed.
@@ -3484,7 +3530,7 @@
 	case $host in
 	*-*-rhapsody* | *-*-darwin1.[012])
 	  # On Rhapsody replace the C library is the System framework
-	  newdeplibs=`$echo "X $newdeplibs" | $Xsed -e 's/ -lc / -framework System /'`
+	  newdeplibs=`$echo "X $newdeplibs" | $Xsed -e 's/ -lc / System.ltframework /'`
 	  ;;
 	esac
 
@@ -3530,6 +3576,13 @@
 	    fi
 	  fi
 	fi
+	# Time to change all our "foo.ltframework" stuff back to "-framework foo"
+	case $host in
+	  *-*-darwin*)
+	    newdeplibs=`$echo "X $newdeplibs" | $Xsed -e 's% \([^ $]*\).ltframework% -framework \1%g'`
+	    dependency_libs=`$echo "X $dependency_libs" | $Xsed -e 's% \([^ $]*\).ltframework% -framework \1%g'`
+	    ;;
+	esac
 	# Done checking deplibs!
 	deplibs=$newdeplibs
       fi
@@ -4119,18 +4172,21 @@
       case $host in
       *-*-rhapsody* | *-*-darwin1.[012])
 	# On Rhapsody replace the C library is the System framework
-	compile_deplibs=`$echo "X $compile_deplibs" | $Xsed -e 's/ -lc / -framework System /'`
-	finalize_deplibs=`$echo "X $finalize_deplibs" | $Xsed -e 's/ -lc / -framework System /'`
+	compile_deplibs=`$echo "X $compile_deplibs" | $Xsed -e 's/ -lc / System.ltframework /'`
+	finalize_deplibs=`$echo "X $finalize_deplibs" | $Xsed -e 's/ -lc / System.ltframework /'`
 	;;
       esac
 
       case $host in
-      *darwin*)
+      *-*-darwin*)
         # Don't allow lazy linking, it breaks C++ global constructors
         if test "$tagname" = CXX ; then
         compile_command="$compile_command ${wl}-bind_at_load"
         finalize_command="$finalize_command ${wl}-bind_at_load"
         fi
+	# Time to change all our "foo.ltframework" stuff back to "-framework foo"
+	compile_deplibs=`$echo "X $compile_deplibs" | $Xsed -e 's% \([^ $]*\).ltframework% -framework \1%g'`
+	finalize_deplibs=`$echo "X $finalize_deplibs" | $Xsed -e 's% \([^ $]*\).ltframework% -framework \1%g'`
         ;;
       esac
 
