--- config/ltmain.sh.orig	Thu Jan 17 08:45:52 2002
+++ config/ltmain.sh	Tue Jun 11 15:58:17 2002
@@ -2858,6 +2858,11 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+          if test "x$verstring" = "x0.0"; then
+            tmp_verstring=
+          else
+            tmp_verstring="$verstring"
+          fi
 	  eval cmds=\"$archive_cmds\"
 	fi
 	IFS="${IFS= 	}"; save_ifs="$IFS"; IFS='~'
@@ -3913,10 +3918,10 @@
 
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
