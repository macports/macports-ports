--- ltmain.sh.orig	Sun Oct 17 10:35:40 2004
+++ ltmain.sh	Sun Oct 17 10:36:19 2004
@@ -1879,7 +1879,7 @@
 	  fi
 	  name=`$echo "X$deplib" | $Xsed -e 's/^-l//'`
 	  for searchdir in $newlib_search_path $lib_search_path $sys_lib_search_path $shlib_search_path; do
-	    for search_ext in .la $shrext .so .a; do
+	    for search_ext in .la $shrext_cmds .so .a; do
 	      # Search the libtool library
 	      lib="$searchdir/lib${name}${search_ext}"
 	      if test -f "$lib"; then
@@ -2862,7 +2862,7 @@
       case $outputname in
       lib*)
 	name=`$echo "X$outputname" | $Xsed -e 's/\.la$//' -e 's/^lib//'`
-	eval shared_ext=\"$shrext\"
+	eval shared_ext=\"$shrext_cmds\"
 	eval libname=\"$libname_spec\"
 	;;
       *)
@@ -2874,7 +2874,7 @@
 	if test "$need_lib_prefix" != no; then
 	  # Add the "lib" prefix for modules if required
 	  name=`$echo "X$outputname" | $Xsed -e 's/\.la$//'`
-	  eval shared_ext=\"$shrext\"
+	  eval shared_ext=\"$shrext_cmds\"
 	  eval libname=\"$libname_spec\"
 	else
 	  libname=`$echo "X$outputname" | $Xsed -e 's/\.la$//'`
@@ -3637,7 +3637,7 @@
 	fi
 
 	# Get the real and link names of the library.
-	eval shared_ext=\"$shrext\"
+	eval shared_ext=\"$shrext_cmds\"
 	eval library_names=\"$library_names_spec\"
 	set dummy $library_names
 	realname="$2"
