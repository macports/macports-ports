--- ltmain.sh.orig	Sun Nov 24 23:02:27 2002
+++ ltmain.sh	Sun Nov 24 23:04:03 2002
@@ -2858,6 +2858,11 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+	  if test "x$verstring" = "x0.0"; then
+	    tmp_verstring=
+	  else
+	    tmp_verstring="$verstring"
+	  fi
 	  eval cmds=\"$archive_cmds\"
 	fi
 	IFS="${IFS= 	}"; save_ifs="$IFS"; IFS='~'
