--- ltmain.sh	Tue Aug 20 10:13:37 2002
+++ ltmain.sh	Sun Nov 24 06:33:34 2002
@@ -2952,7 +2952,17 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+	  if test "x$verstring" = "x0.0"; then
+	    tmp_verstring=
+	  else
+	    tmp_verstring="$verstring"
+	  fi
+	  save_deplibs="$deplibs"
+	  for conv in $convenience; do
+	    deplibs="${deplibs%$conv*} ${deplibs#*$conv}"
+	  done
 	  eval cmds=\"$archive_cmds\"
+	  deplibs="$save_deplibs"
 	fi
 	save_ifs="$IFS"; IFS='~'
 	for cmd in $cmds; do
@@ -4006,10 +4016,10 @@
 
 # Directory that this library needs to be installed in:
 libdir='$install_libdir'"
-	  if test "$installed" = no && test "$need_relink" = yes; then
-	    $echo >> $output "\
-relink_command=\"$relink_command\""
-	  fi
+#	  if test "$installed" = no && test "$need_relink" = yes; then
+#	    $echo >> $output "\
+#relink_command=\"$relink_command\""
+#	  fi
 	done
       fi 
