--- ltmain.sh.orig	Sat Feb  1 13:04:12 2003
+++ ltmain.sh	Mon Feb 17 16:15:57 2003
@@ -49,14 +49,14 @@
 fi
 
 # The name of this program.
-progname=`$echo "$0" | ${SED} 's%^.*/%%'`
+progname=`$echo "$0" | sed 's%^.*/%%'`
 modename="$progname"
 
 # Constants.
 PROGRAM=ltmain.sh
 PACKAGE=libtool
-VERSION=1.4.3
-TIMESTAMP=" (1.922.2.111 2002/10/23 02:54:36)"
+VERSION=1.4.2
+TIMESTAMP=" (1.922.2.53 2001/09/11 03:18:52)"
 
 default_mode=
 help="Try \`$progname --help' for more information."
@@ -67,19 +67,10 @@
 
 # Sed substitution that helps us do robust quoting.  It backslashifies
 # metacharacters that are still active within double-quoted strings.
-Xsed="${SED}"' -e 1s/^X//'
+Xsed='sed -e 1s/^X//'
 sed_quote_subst='s/\([\\`\\"$\\\\]\)/\\\1/g'
-# test EBCDIC or ASCII                                                         
-case `echo A|od -x` in                                                         
- *[Cc]1*) # EBCDIC based system                                                
-  SP2NL="tr '\100' '\n'"                                                       
-  NL2SP="tr '\r\n' '\100\100'"                                                 
-  ;;                                                                           
- *) # Assume ASCII based system                                                
-  SP2NL="tr '\040' '\012'"                                                     
-  NL2SP="tr '\015\012' '\040\040'"                                             
-  ;;                                                                           
-esac                                                                           
+SP2NL='tr \040 \012'
+NL2SP='tr \015\012 \040\040'
 
 # NLS nuisances.
 # Only set LANG and LC_ALL to C if already set.
@@ -153,7 +144,7 @@
     ;;
 
   --config)
-    ${SED} -e '1,/^# ### BEGIN LIBTOOL CONFIG/d' -e '/^# ### END LIBTOOL CONFIG/,$d' $0
+    sed -e '1,/^# ### BEGIN LIBTOOL CONFIG/d' -e '/^# ### END LIBTOOL CONFIG/,$d' $0
     exit 0
     ;;
 
@@ -186,8 +177,6 @@
   --mode) prevopt="--mode" prev=mode ;;
   --mode=*) mode="$optarg" ;;
 
-  --preserve-dup-deps) duplicate_deps="yes" ;;
-
   --quiet | --silent)
     show=:
     ;;
@@ -226,7 +215,7 @@
   # Infer the operation mode.
   if test -z "$mode"; then
     case $nonopt in
-    *cc | *++ | gcc* | *-gcc* | g++* | xlc*)
+    *cc | *++ | gcc* | *-gcc*)
       mode=link
       for arg
       do
@@ -478,7 +467,7 @@
       pic_mode=default
       ;;
     esac
-    if test "$pic_mode" = no && test "$deplibs_check_method" != pass_all; then
+    if test $pic_mode = no && test "$deplibs_check_method" != pass_all; then
       # non-PIC code in shared libraries is not supported
       pic_mode=default
     fi
@@ -768,7 +757,6 @@
     linker_flags=
     dllsearchpath=
     lib_search_path=`pwd`
-    inst_prefix_dir=
 
     avoid_version=no
     dlfiles=
@@ -899,11 +887,6 @@
 	  prev=
 	  continue
 	  ;;
-	inst_prefix)
-	  inst_prefix_dir="$arg"
-	  prev=
-	  continue
-	  ;;
 	release)
 	  release="-$arg"
 	  prev=
@@ -1005,16 +988,11 @@
 	continue
 	;;
 
-      -inst-prefix-dir)
-       prev=inst_prefix
-       continue
-       ;;
-
       # The native IRIX linker understands -LANG:*, -LIST:* and -LNO:*
       # so, if we see these flags be careful not to treat them like -L
       -L[A-Z][A-Z]*:*)
 	case $with_gcc/$host in
-	no/*-*-irix* | no/*-*-nonstopux*)
+	no/*-*-irix*)
 	  compile_command="$compile_command $arg"
 	  finalize_command="$finalize_command $arg"
 	  ;;
@@ -1065,14 +1043,14 @@
 	    # These systems don't actually have a C library (as such)
 	    test "X$arg" = "X-lc" && continue
 	    ;;
-	  *-*-openbsd* | *-*-freebsd*)
+	  *-*-openbsd*)
 	    # Do not include libc due to us having libc/libc_r.
 	    test "X$arg" = "X-lc" && continue
 	    ;;
 	  esac
 	 elif test "X$arg" = "X-lc_r"; then
 	  case $host in
-	 *-*-openbsd* | *-*-freebsd*)
+	  *-*-openbsd*)
 	    # Do not include libc_r directly, use -pthread flag.
 	    continue
 	    ;;
@@ -1352,11 +1330,9 @@
     # Find all interdependent deplibs by searching for libraries
     # that are linked more than once (e.g. -la -lb -la)
     for deplib in $deplibs; do
-      if test "X$duplicate_deps" = "Xyes" ; then
-	case "$libs " in
-	*" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
-	esac
-      fi
+      case "$libs " in
+      *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
+      esac
       libs="$libs $deplib"
     done
     deplibs=
@@ -1485,12 +1461,10 @@
 	  lib)
 	    if test "$deplibs_check_method" != pass_all; then
 	      echo
-	      echo "*** Warning: Trying to link with static lib archive $deplib."
+	      echo "*** Warning: This library needs some functionality provided by $deplib."
 	      echo "*** I have the capability to make that library automatically link in when"
 	      echo "*** you link to this library.  But I can only do this if you have a"
-	      echo "*** shared version of the library, which you do not appear to have"
-	      echo "*** because the file extensions .$libext of this argument makes me believe"
-	      echo "*** that it is just a static archive that I should not used here."
+	      echo "*** shared version of the library, which you do not appear to have."
 	    else
 	      echo
 	      echo "*** Warning: Linking the shared library $output against the"
@@ -1534,7 +1508,7 @@
 	fi
 
 	# Check to see that this really is a libtool archive.
-	if (${SED} -e '2q' $lib | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then :
+	if (sed -e '2q' $lib | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then :
 	else
 	  $echo "$modename: \`$lib' is not a valid libtool archive" 1>&2
 	  exit 1
@@ -1581,11 +1555,9 @@
 	    tmp_libs=
 	    for deplib in $dependency_libs; do
 	      deplibs="$deplib $deplibs"
-              if test "X$duplicate_deps" = "Xyes" ; then
-	        case "$tmp_libs " in
-	        *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
-	        esac
-              fi
+	      case "$tmp_libs " in
+	      *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
+	      esac
 	      tmp_libs="$tmp_libs $deplib"
 	    done
 	  elif test $linkmode != prog && test $linkmode != lib; then
@@ -1708,11 +1680,9 @@
 	      # or/and link against static libraries
 	      newdependency_libs="$deplib $newdependency_libs"
 	    fi
-	    if test "X$duplicate_deps" = "Xyes" ; then
-	      case "$tmp_libs " in
-	      *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
-	      esac
-	    fi
+	    case "$tmp_libs " in
+	    *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
+	    esac
 	    tmp_libs="$tmp_libs $deplib"
 	  done # for deplib
 	  continue
@@ -1796,8 +1766,8 @@
 
 	    # Make a new name for the extract_expsyms_cmds to use
 	    soroot="$soname"
-	    soname=`echo $soroot | ${SED} -e 's/^.*\///'`
-	    newlib="libimp-`echo $soname | ${SED} 's/^lib//;s/\.dll$//'`.a"
+	    soname=`echo $soroot | sed -e 's/^.*\///'`
+	    newlib="libimp-`echo $soname | sed 's/^lib//;s/\.dll$//'`.a"
 
 	    # If the library has no export list, then create one now
 	    if test -f "$output_objdir/$soname-def"; then :
@@ -1857,14 +1827,6 @@
 		add="$dir/$linklib"
 	      elif test "$hardcode_minus_L" = yes; then
 		add_dir="-L$dir"
-		# Try looking first in the location we're being installed to.
-		if test -n "$inst_prefix_dir"; then
-		  case "$libdir" in
-		  [\/]*)
-		    add_dir="-L$inst_prefix_dir$libdir $add_dir"
-		    ;;
-		  esac
-		fi
 		add="-l$name"
 	      elif test "$hardcode_shlibpath_var" = yes; then
 		add_shlibpath="$dir"
@@ -1922,14 +1884,10 @@
 	      add="-l$name"
 	    else
 	      # We cannot seem to hardcode it, guess we'll fake it.
-	      add_dir="-L$libdir"
-	      # Try looking first in the location we're being installed to.
-	      if test -n "$inst_prefix_dir"; then
-		case "$libdir" in
-		[\/]*)
-		  add_dir="-L$inst_prefix_dir$libdir $add_dir"
-		  ;;
-		esac
+	      if test "X$installed" = Xyes; then
+		add_dir="-L$libdir"
+	      else
+		add_dir="-L$DESTDIR$libdir"
 	      fi
 	      add="-l$name"
 	    fi
@@ -1972,14 +1930,13 @@
 	    # Just print a warning and add the library to dependency_libs so
 	    # that the program can be linked against the static library.
 	    echo
-	    echo "*** Warning: This system can not link to static lib archive $lib."
+	    echo "*** Warning: This library needs some functionality provided by $lib."
 	    echo "*** I have the capability to make that library automatically link in when"
 	    echo "*** you link to this library.  But I can only do this if you have a"
 	    echo "*** shared version of the library, which you do not appear to have."
 	    if test "$module" = yes; then
-	      echo "*** But as you try to build a module library, libtool will still create "
-	      echo "*** a static module, that should work as long as the dlopening application"
-	      echo "*** is linked with the -dlopen flag to resolve symbols at runtime."
+	      echo "*** Therefore, libtool will create a static module, that should work "
+	      echo "*** as long as the dlopening application is linked with the -dlopen flag."
 	      if test -z "$global_symbol_pipe"; then
 		echo
 		echo "*** However, this would only work if libtool was able to extract symbol"
@@ -2028,11 +1985,9 @@
 	  tmp_libs=
 	  for deplib in $dependency_libs; do
 	    newdependency_libs="$deplib $newdependency_libs"
-	    if test "X$duplicate_deps" = "Xyes" ; then
-	      case "$tmp_libs " in
-	      *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
-	      esac
-	    fi
+	    case "$tmp_libs " in
+	    *" $deplib "*) specialdeplibs="$specialdeplibs $deplib" ;;
+	    esac
 	    tmp_libs="$tmp_libs $deplib"
 	  done
 
@@ -2058,7 +2013,7 @@
 		if grep "^installed=no" $deplib > /dev/null; then
 		  path="-L$absdir/$objdir"
 		else
-		  eval libdir=`${SED} -n -e 's/^libdir=\(.*\)$/\1/p' $deplib`
+		  eval libdir=`sed -n -e 's/^libdir=\(.*\)$/\1/p' $deplib`
 		  if test -z "$libdir"; then
 		    $echo "$modename: \`$deplib' is not a valid libtool archive" 1>&2
 		    exit 1
@@ -2322,21 +2277,16 @@
 	  versuffix=".$current";
 	  ;;
 
-	irix | nonstopux)
+	irix)
 	  major=`expr $current - $age + 1`
-
-	  case $version_type in
-	    nonstopux) verstring_prefix=nonstopux ;;
-	    *)         verstring_prefix=sgi ;;
-	  esac
-	  verstring="$verstring_prefix$major.$revision"
+	  verstring="sgi$major.$revision"
 
 	  # Add in all the interfaces that we are compatible with.
 	  loop=$revision
 	  while test $loop != 0; do
 	    iface=`expr $revision - $loop`
 	    loop=`expr $loop - 1`
-	    verstring="$verstring_prefix$major.$iface:$verstring"
+	    verstring="sgi$major.$iface:$verstring"
 	  done
 
 	  # Before this point, $major must not contain `.'.
@@ -2350,7 +2300,7 @@
 	  ;;
 
 	osf)
-	  major=.`expr $current - $age`
+	  major=`expr $current - $age`
 	  versuffix=".$current.$age.$revision"
 	  verstring="$current.$age.$revision"
 
@@ -2442,9 +2392,9 @@
 
       # Eliminate all temporary directories.
       for path in $notinst_path; do
-	lib_search_path=`echo "$lib_search_path " | ${SED} -e 's% $path % %g'`
-	deplibs=`echo "$deplibs " | ${SED} -e 's% -L$path % %g'`
-	dependency_libs=`echo "$dependency_libs " | ${SED} -e 's% -L$path % %g'`
+	lib_search_path=`echo "$lib_search_path " | sed -e 's% $path % %g'`
+	deplibs=`echo "$deplibs " | sed -e 's% -L$path % %g'`
+	dependency_libs=`echo "$dependency_libs " | sed -e 's% -L$path % %g'`
       done
 
       if test -n "$xrpath"; then
@@ -2495,7 +2445,7 @@
 	  *-*-netbsd*)
 	    # Don't link with libc until the a.out ld.so is fixed.
 	    ;;
-	  *-*-openbsd* | *-*-freebsd*)
+	  *-*-openbsd*)
 	    # Do not include libc due to us having libc/libc_r.
 	    ;;
 	  *)
@@ -2556,20 +2506,18 @@
 		else
 		  droppeddeps=yes
 		  echo
-		  echo "*** Warning: dynamic linker does not accept needed library $i."
+		  echo "*** Warning: This library needs some functionality provided by $i."
 		  echo "*** I have the capability to make that library automatically link in when"
 		  echo "*** you link to this library.  But I can only do this if you have a"
-		  echo "*** shared version of the library, which I believe you do not have"
-		  echo "*** because a test_compile did reveal that the linker did not use it for"
-		  echo "*** its dynamic dependency list that programs get resolved with at runtime."
+		  echo "*** shared version of the library, which you do not appear to have."
 		fi
 	      else
 		newdeplibs="$newdeplibs $i"
 	      fi
 	    done
 	  else
-	    # Error occured in the first compile.  Let's try to salvage
-	    # the situation: Compile a separate program for each library.
+	    # Error occured in the first compile.  Let's try to salvage the situation:
+	    # Compile a seperate program for each library.
 	    for i in $deplibs; do
 	      name="`expr $i : '-l\(.*\)'`"
 	     # If $name is empty we are operating on a -L argument.
@@ -2588,12 +2536,10 @@
 		  else
 		    droppeddeps=yes
 		    echo
-		    echo "*** Warning: dynamic linker does not accept needed library $i."
+		    echo "*** Warning: This library needs some functionality provided by $i."
 		    echo "*** I have the capability to make that library automatically link in when"
 		    echo "*** you link to this library.  But I can only do this if you have a"
-		    echo "*** shared version of the library, which you do not appear to have"
-		    echo "*** because a test_compile did reveal that the linker did not use this one"
-		    echo "*** as a dynamic dependency that programs can get resolved with at runtime."
+		    echo "*** shared version of the library, which you do not appear to have."
 		  fi
 		else
 		  droppeddeps=yes
@@ -2632,14 +2578,14 @@
 		      # but so what?
 		      potlib="$potent_lib"
 		      while test -h "$potlib" 2>/dev/null; do
-			potliblink=`ls -ld $potlib | ${SED} 's/.* -> //'`
+			potliblink=`ls -ld $potlib | sed 's/.* -> //'`
 			case $potliblink in
 			[\\/]* | [A-Za-z]:[\\/]*) potlib="$potliblink";;
 			*) potlib=`$echo "X$potlib" | $Xsed -e 's,[^/]*$,,'`"$potliblink";;
 			esac
 		      done
 		      if eval $file_magic_cmd \"\$potlib\" 2>/dev/null \
-			 | ${SED} 10q \
+			 | sed 10q \
 			 | egrep "$file_magic_regex" > /dev/null; then
 			newdeplibs="$newdeplibs $a_deplib"
 			a_deplib=""
@@ -2650,17 +2596,10 @@
 	      if test -n "$a_deplib" ; then
 		droppeddeps=yes
 		echo
-		echo "*** Warning: linker path does not have real file for library $a_deplib."
+		echo "*** Warning: This library needs some functionality provided by $a_deplib."
 		echo "*** I have the capability to make that library automatically link in when"
 		echo "*** you link to this library.  But I can only do this if you have a"
-		echo "*** shared version of the library, which you do not appear to have"
-		echo "*** because I did check the linker path looking for a file starting"
-		if test -z "$potlib" ; then
-		  echo "*** with $libname but no candidates were found. (...for file magic test)"
-		else
-		  echo "*** with $libname and none of the candidates passed a file format test"
-		  echo "*** using a file magic. Last file checked: $potlib"
-		fi
+		echo "*** shared version of the library, which you do not appear to have."
 	      fi
 	    else
 	      # Add a -L argument.
@@ -2679,9 +2618,8 @@
 	      for i in $lib_search_path $sys_lib_search_path $shlib_search_path; do
 		potential_libs=`ls $i/$libname[.-]* 2>/dev/null`
 		for potent_lib in $potential_libs; do
-		  potlib="$potent_lib" # see symlink-check below in file_magic test
 		  if eval echo \"$potent_lib\" 2>/dev/null \
-		      | ${SED} 10q \
+		      | sed 10q \
 		      | egrep "$match_pattern_regex" > /dev/null; then
 		    newdeplibs="$newdeplibs $a_deplib"
 		    a_deplib=""
@@ -2692,17 +2630,10 @@
 	      if test -n "$a_deplib" ; then
 		droppeddeps=yes
 		echo
-		echo "*** Warning: linker path does not have real file for library $a_deplib."
+		echo "*** Warning: This library needs some functionality provided by $a_deplib."
 		echo "*** I have the capability to make that library automatically link in when"
 		echo "*** you link to this library.  But I can only do this if you have a"
-		echo "*** shared version of the library, which you do not appear to have"
-		echo "*** because I did check the linker path looking for a file starting"
-		if test -z "$potlib" ; then
-		  echo "*** with $libname but no candidates were found. (...for regex pattern test)"
-		else
-		  echo "*** with $libname and none of the candidates passed a file format test"
-		  echo "*** using a regex pattern. Last file checked: $potlib"
-		fi
+		echo "*** shared version of the library, which you do not appear to have."
 	      fi
 	    else
 	      # Add a -L argument.
@@ -2967,18 +2898,7 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
-	  save_deplibs="$deplibs"
-	  for conv in $convenience; do
-	    tmp_deplibs=
-	    for test_deplib in $deplibs; do
-	      if test "$test_deplib" != "$conv"; then
-		tmp_deplibs="$tmp_deplibs $test_deplib"
-	      fi
-	    done
-	    deplibs="$tmp_deplibs"
-	  done
 	  eval cmds=\"$archive_cmds\"
-	  deplibs="$save_deplibs"
 	fi
 	save_ifs="$IFS"; IFS='~'
 	for cmd in $cmds; do
@@ -3177,7 +3097,7 @@
 
     prog)
       case $host in
-	*cygwin*) output=`echo $output | ${SED} -e 's,.exe$,,;s,$,.exe,'` ;;
+	*cygwin*) output=`echo $output | sed -e 's,.exe$,,;s,$,.exe,'` ;;
       esac
       if test -n "$vinfo"; then
 	$echo "$modename: warning: \`-version-info' is ignored for programs" 1>&2
@@ -3199,13 +3119,6 @@
 	# On Rhapsody replace the C library is the System framework
 	compile_deplibs=`$echo "X $compile_deplibs" | $Xsed -e 's/ -lc / -framework System /'`
 	finalize_deplibs=`$echo "X $finalize_deplibs" | $Xsed -e 's/ -lc / -framework System /'`
-	case $host in
-	*darwin*)
-	  # Don't allow lazy linking, it breaks C++ global constructors
-	  compile_command="$compile_command ${wl}-bind_at_load"
-	  finalize_command="$finalize_command ${wl}-bind_at_load"
-	  ;;
-	esac
 	;;
       esac
 
@@ -3372,9 +3285,9 @@
 	    if test -z "$export_symbols"; then
 	      export_symbols="$output_objdir/$output.exp"
 	      $run $rm $export_symbols
-	      $run eval "${SED} -n -e '/^: @PROGRAM@$/d' -e 's/^.* \(.*\)$/\1/p' "'< "$nlist" > "$export_symbols"'
+	      $run eval "sed -n -e '/^: @PROGRAM@$/d' -e 's/^.* \(.*\)$/\1/p' "'< "$nlist" > "$export_symbols"'
 	    else
-	      $run eval "${SED} -e 's/\([][.*^$]\)/\\\1/g' -e 's/^/ /' -e 's/$/$/'"' < "$export_symbols" > "$output_objdir/$output.exp"'
+	      $run eval "sed -e 's/\([][.*^$]\)/\\\1/g' -e 's/^/ /' -e 's/$/$/'"' < "$export_symbols" > "$output_objdir/$output.exp"'
 	      $run eval 'grep -f "$output_objdir/$output.exp" < "$nlist" > "$nlist"T'
 	      $run eval 'mv "$nlist"T "$nlist"'
 	    fi
@@ -3382,7 +3295,7 @@
 
 	  for arg in $dlprefiles; do
 	    $show "extracting global C symbols from \`$arg'"
-	    name=`echo "$arg" | ${SED} -e 's%^.*/%%'`
+	    name=`echo "$arg" | sed -e 's%^.*/%%'`
 	    $run eval 'echo ": $name " >> "$nlist"'
 	    $run eval "$NM $arg | $global_symbol_pipe >> '$nlist'"
 	  done
@@ -3397,13 +3310,7 @@
 	    fi
 
 	    # Try sorting and uniquifying the output.
-	    if grep -v "^: " < "$nlist" |
-		if sort -k 3 </dev/null >/dev/null 2>&1; then
-		  sort -k 3
-		else
-		  sort +2
-		fi |
-		uniq > "$nlist"S; then
+	    if grep -v "^: " < "$nlist" | sort +2 | uniq > "$nlist"S; then
 	      :
 	    else
 	      grep -v "^: " < "$nlist" > "$nlist"S
@@ -3625,7 +3532,7 @@
 	    relink_command="$var=\"$var_value\"; export $var; $relink_command"
 	  fi
 	done
-	relink_command="(cd `pwd`; $relink_command)"
+	relink_command="cd `pwd`; $relink_command"
 	relink_command=`$echo "X$relink_command" | $Xsed -e "$sed_quote_subst"`
       fi
 
@@ -3645,7 +3552,7 @@
 	# win32 will think the script is a binary if it has
 	# a .exe suffix, so we strip it off here.
 	case $output in
-	  *.exe) output=`echo $output|${SED} 's,.exe$,,'` ;;
+	  *.exe) output=`echo $output|sed 's,.exe$,,'` ;;
 	esac
 	# test for cygwin because mv fails w/o .exe extensions
 	case $host in
@@ -3669,7 +3576,7 @@
 
 # Sed substitution that helps us do robust quoting.  It backslashifies
 # metacharacters that are still active within double-quoted strings.
-Xsed="${SED}"' -e 1s/^X//'
+Xsed='sed -e 1s/^X//'
 sed_quote_subst='$sed_quote_subst'
 
 # The HP-UX ksh and POSIX shell print the target directory to stdout
@@ -3707,7 +3614,7 @@
   test \"x\$thisdir\" = \"x\$file\" && thisdir=.
 
   # Follow symbolic links until we get to the real thisdir.
-  file=\`ls -ld \"\$file\" | ${SED} -n 's/.*-> //p'\`
+  file=\`ls -ld \"\$file\" | sed -n 's/.*-> //p'\`
   while test -n \"\$file\"; do
     destdir=\`\$echo \"X\$file\" | \$Xsed -e 's%/[^/]*\$%%'\`
 
@@ -3720,7 +3627,7 @@
     fi
 
     file=\`\$echo \"X\$file\" | \$Xsed -e 's%^.*/%%'\`
-    file=\`ls -ld \"\$thisdir/\$file\" | ${SED} -n 's/.*-> //p'\`
+    file=\`ls -ld \"\$thisdir/\$file\" | sed -n 's/.*-> //p'\`
   done
 
   # Try to get the absolute directory name.
@@ -3734,7 +3641,7 @@
   progdir=\"\$thisdir/$objdir\"
 
   if test ! -f \"\$progdir/\$program\" || \\
-     { file=\`ls -1dt \"\$progdir/\$program\" \"\$progdir/../\$program\" 2>/dev/null | ${SED} 1q\`; \\
+     { file=\`ls -1dt \"\$progdir/\$program\" \"\$progdir/../\$program\" 2>/dev/null | sed 1q\`; \\
        test \"X\$file\" != \"X\$progdir/\$program\"; }; then
 
     file=\"\$\$-\$program\"
@@ -3780,7 +3687,7 @@
     $shlibpath_var=\"$temp_rpath\$$shlibpath_var\"
 
     # Some systems cannot cope with colon-terminated $shlibpath_var
-    # The second colon is a workaround for a bug in BeOS R4 ${SED}
+    # The second colon is a workaround for a bug in BeOS R4 sed
     $shlibpath_var=\`\$echo \"X\$$shlibpath_var\" | \$Xsed -e 's/::*\$//'\`
 
     export $shlibpath_var
@@ -3955,7 +3862,7 @@
 	fi
       done
       # Quote the link command for shipping.
-      relink_command="(cd `pwd`; $SHELL $0 --mode=relink $libtool_args @inst_prefix_dir@)"
+      relink_command="cd `pwd`; $SHELL $0 --mode=relink $libtool_args"
       relink_command=`$echo "X$relink_command" | $Xsed -e "$sed_quote_subst"`
 
       # Only create the output if not a dry run.
@@ -3972,7 +3879,7 @@
 	      case $deplib in
 	      *.la)
 		name=`$echo "X$deplib" | $Xsed -e 's%^.*/%%'`
-		eval libdir=`${SED} -n -e 's/^libdir=\(.*\)$/\1/p' $deplib`
+		eval libdir=`sed -n -e 's/^libdir=\(.*\)$/\1/p' $deplib`
 		if test -z "$libdir"; then
 		  $echo "$modename: \`$deplib' is not a valid libtool archive" 1>&2
 		  exit 1
@@ -3986,7 +3893,7 @@
 	    newdlfiles=
 	    for lib in $dlfiles; do
 	      name=`$echo "X$lib" | $Xsed -e 's%^.*/%%'`
-	      eval libdir=`${SED} -n -e 's/^libdir=\(.*\)$/\1/p' $lib`
+	      eval libdir=`sed -n -e 's/^libdir=\(.*\)$/\1/p' $lib`
 	      if test -z "$libdir"; then
 		$echo "$modename: \`$lib' is not a valid libtool archive" 1>&2
 		exit 1
@@ -3997,7 +3904,7 @@
 	    newdlprefiles=
 	    for lib in $dlprefiles; do
 	      name=`$echo "X$lib" | $Xsed -e 's%^.*/%%'`
-	      eval libdir=`${SED} -n -e 's/^libdir=\(.*\)$/\1/p' $lib`
+	      eval libdir=`sed -n -e 's/^libdir=\(.*\)$/\1/p' $lib`
 	      if test -z "$libdir"; then
 		$echo "$modename: \`$lib' is not a valid libtool archive" 1>&2
 		exit 1
@@ -4221,7 +4128,7 @@
 
       *.la)
 	# Check to see that this really is a libtool archive.
-	if (${SED} -e '2q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then :
+	if (sed -e '2q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then :
 	else
 	  $echo "$modename: \`$file' is not a valid libtool archive" 1>&2
 	  $echo "$help" 1>&2
@@ -4238,12 +4145,21 @@
 	esac
 
 	# Add the libdir to current_libdirs if it is the destination.
+	DESTDIR=
 	if test "X$destdir" = "X$libdir"; then
 	  case "$current_libdirs " in
 	  *" $libdir "*) ;;
 	  *) current_libdirs="$current_libdirs $libdir" ;;
 	  esac
 	else
+	  case "$destdir" in
+	    *"$libdir")
+	      DESTDIR=`$echo "$destdir" | sed -e 's!'"$libdir"'$!!'`
+	      if test "X$destdir" != "X$DESTDIR$libdir"; then
+		DESTDIR=
+	      fi
+	      ;;
+	  esac
 	  # Note the libdir as a future libdir.
 	  case "$future_libdirs " in
 	  *" $libdir "*) ;;
@@ -4256,32 +4172,16 @@
 	dir="$dir$objdir"
 
 	if test -n "$relink_command"; then
-          # Determine the prefix the user has applied to our future dir.
-          inst_prefix_dir=`$echo "$destdir" | sed "s%$libdir\$%%"`
- 
-          # Don't allow the user to place us outside of our expected
-          # location b/c this prevents finding dependent libraries that
-          # are installed to the same prefix.
-          if test "$inst_prefix_dir" = "$destdir"; then
-            $echo "$modename: error: cannot install \`$file' to a directory not ending in $libdir" 1>&2
-            exit 1
-          fi
- 
-          if test -n "$inst_prefix_dir"; then
-            # Stick the inst_prefix_dir data into the link command.
-            relink_command=`$echo "$relink_command" | sed "s%@inst_prefix_dir@%-inst-prefix-dir $inst_prefix_dir%"`
-          else
-            relink_command=`$echo "$relink_command" | sed "s%@inst_prefix_dir@%%"`
-          fi
-
 	  $echo "$modename: warning: relinking \`$file'" 1>&2
+	  export DESTDIR
 	  $show "$relink_command"
 	  if $run eval "$relink_command"; then :
 	  else
 	    $echo "$modename: error: relink \`$file' with the above command before installing it" 1>&2
-	    exit 1
+	    continue
 	  fi
 	fi
+	unset DESTDIR
 
 	# See the names of the shared library.
 	set dummy $library_names
@@ -4388,27 +4288,19 @@
 	fi
 
 	# Do a test to see if this is really a libtool program.
-	case $host in
-	*cygwin*|*mingw*)
-	    wrapper=`echo $file | ${SED} -e 's,.exe$,,'`
-	    ;;
-	*)
-	    wrapper=$file
-	    ;;
-	esac
-	if (${SED} -e '4q' $wrapper | egrep "^# Generated by .*$PACKAGE")>/dev/null 2>&1; then
+	if (sed -e '4q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
 	  notinst_deplibs=
 	  relink_command=
 
 	  # If there is no directory component, then add one.
 	  case $file in
-	  */* | *\\*) . $wrapper ;;
-	  *) . ./$wrapper ;;
+	  */* | *\\*) . $file ;;
+	  *) . ./$file ;;
 	  esac
 
 	  # Check the variables that should have been set.
 	  if test -z "$notinst_deplibs"; then
-	    $echo "$modename: invalid libtool wrapper script \`$wrapper'" 1>&2
+	    $echo "$modename: invalid libtool wrapper script \`$file'" 1>&2
 	    exit 1
 	  fi
 
@@ -4433,8 +4325,8 @@
 	  relink_command=
 	  # If there is no directory component, then add one.
 	  case $file in
-	  */* | *\\*) . $wrapper ;;
-	  *) . ./$wrapper ;;
+	  */* | *\\*) . $file ;;
+	  *) . ./$file ;;
 	  esac
 
 	  outputname=
@@ -4482,7 +4374,7 @@
 	    destfile=$destfile.exe
 	    ;;
 	  *:*.exe)
-	    destfile=`echo $destfile | ${SED} -e 's,.exe$,,'`
+	    destfile=`echo $destfile | sed -e 's,.exe$,,'`
 	    ;;
 	  esac
 	  ;;
@@ -4630,7 +4522,7 @@
       case $file in
       *.la)
 	# Check to see that this really is a libtool archive.
-	if (${SED} -e '2q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then :
+	if (sed -e '2q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then :
 	else
 	  $echo "$modename: \`$lib' is not a valid libtool archive" 1>&2
 	  $echo "$help" 1>&2
@@ -4701,7 +4593,7 @@
       -*) ;;
       *)
 	# Do a test to see if this is really a libtool program.
-	if (${SED} -e '4q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
+	if (sed -e '4q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
 	  # If there is no directory component, then add one.
 	  case $file in
 	  */* | *\\*) . $file ;;
@@ -4733,7 +4625,7 @@
       fi
 
       # Now prepare to actually exec the command.
-      exec_cmd="\$cmd$args"
+      exec_cmd='"$cmd"$args'
     else
       # Display what would be done.
       if test -n "$shlibpath_var"; then
@@ -4810,7 +4702,7 @@
       case $name in
       *.la)
 	# Possibly a libtool archive, so verify it.
-	if (${SED} -e '2q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
+	if (sed -e '2q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
 	  . $dir/$name
 
 	  # Delete the libtool libraries and symlinks.
@@ -4865,7 +4757,7 @@
       *)
 	# Do a test to see if this is a libtool program.
 	if test $mode = clean &&
-	   (${SED} -e '4q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
+	   (sed -e '4q' $file | egrep "^# Generated by .*$PACKAGE") >/dev/null 2>&1; then
 	  relink_command=
 	  . $dir/$file
 
