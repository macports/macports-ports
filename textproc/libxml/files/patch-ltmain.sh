diff -Naur ltmain.sh ltmain.sh
--- ltmain.sh	Sun Jul  7 05:00:15 2002
+++ ltmain.sh	Sun Jul 14 15:53:31 2002
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
