--- ../fcgi-2.4.0.orig/ltmain.sh	Fri Sep 21 09:49:36 2001
+++ ltmain.sh	Mon Apr 12 14:43:59 2004
@@ -770,6 +770,7 @@
     temp_rpath=
     thread_safe=no
     vinfo=
+    vinfo_number=no
 
     # We need to know -static, to get the right output filenames.
     for arg
@@ -1118,6 +1119,11 @@
 	prev=vinfo
 	continue
 	;;
+      -version-number)
+	prev=vinfo
+	vinfo_number=yes
+	continue
+	;;
 
       -Wc,*)
 	args=`$echo "X$arg" | $Xsed -e "$sed_quote_subst" -e 's/^-Wc,//'`
@@ -1716,7 +1722,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
@@ -2185,9 +2191,46 @@
 	  exit 1
 	fi
 
-	current="$2"
-	revision="$3"
-	age="$4"
+	# convert absolute version numbers to libtool ages
+	# this retains compatibility with .la files and attempts
+	# to make the code below a bit more comprehensible
+	
+	case $vinfo_number in
+	yes)
+	  number_major="$2"
+	  number_minor="$3"
+	  number_revision="$4"
+	  #
+	  # There are really only two kinds -- those that
+	  # use the current revision as the major version
+	  # and those that subtract age and use age as
+	  # a minor version.  But, then there is irix
+	  # which has an extra 1 added just for fun
+	  #
+	  case $version_type in
+	  darwin|linux|osf|windows)
+	    current=`expr $number_major + $number_minor`
+	    age="$number_minor"
+	    revision="$number_revision"
+	    ;;
+	  freebsd-aout|freebsd-elf|sunos)
+	    current="$number_major"
+	    revision="$number_minor"
+	    age="0"
+	    ;;
+	  irix|nonstopux)
+	    current=`expr $number_major + $number_minor - 1`
+	    age="$number_minor"
+	    revision="$number_minor"
+	    ;;
+	  esac
+	  ;;
+	no)
+	  current="$2"
+	  revision="$3"
+	  age="$4"
+	  ;;
+	esac
 
 	# Check that each of the things are valid numbers.
 	case $current in
