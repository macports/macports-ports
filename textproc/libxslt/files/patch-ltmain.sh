diff -uNbr ltmain.sh libxslt-1.0.18-new/ltmain.sh
--- ltmain.sh	Mon May 27 17:31:19 2002
+++ libxslt-1.0.18-new/ltmain.sh	Thu Jun  6 22:49:06 2002
@@ -2858,6 +2858,11 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+         if test "x$verstring" = "x0.0"; then
+           tmp_verstring=
+         else
+           tmp_verstring="$verstring"
+         fi
 	  eval cmds=\"$archive_cmds\"
 	fi
 	IFS="${IFS= 	}"; save_ifs="$IFS"; IFS='~'
