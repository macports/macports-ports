--- ltmain.sh.orig	2003-01-08 14:49:04.000000000 -0500
+++ ltmain.sh	2005-04-27 17:12:08.000000000 -0400
@@ -1683,7 +1683,7 @@
 	if test -z "$libdir"; then
 	  # Link the convenience library
 	  if test "$linkmode" = lib; then
-	    deplibs="$dir/$old_library $deplibs"
+	    :
 	  elif test "$linkmode,$pass" = "prog,link"; then
 	    compile_deplibs="$dir/$old_library $compile_deplibs"
 	    finalize_deplibs="$dir/$old_library $finalize_deplibs"
@@ -1777,7 +1777,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
