--- ltmain.sh-orig	Sat Jun  1 17:50:56 2002
+++ ltmain.sh	Tue Jul  2 07:31:38 2002
@@ -2894,6 +2894,11 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+      if test "x$verstring" = "x0.0"; then
+        tmp_verstring=
+      else
+        tmp_verstring="$verstring"
+      fi
 	  eval cmds=\"$archive_cmds\"
 	fi
 	save_ifs="$IFS"; IFS='~'
@@ -3948,10 +3953,10 @@
 
 # Directory that this library needs to be installed in:
 libdir='$install_libdir'"
-	  if test "$installed" = no && test $need_relink = yes; then
-	    $echo >> $output "\
-relink_command=\"$relink_command\""
-	  fi
+#	  if test "$installed" = no && test $need_relink = yes; then
+#	    $echo >> $output "\
+#relink_command=\"$relink_command\""
+#	  fi
 	done
       fi
 
