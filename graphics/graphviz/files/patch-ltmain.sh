--- ltmain.sh.orig	Wed Jul  9 18:00:20 2003
+++ ltmain.sh	Wed Jul 16 06:13:35 2003
@@ -2894,7 +2894,18 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+	  save_deplibs="$deplibs"
+	  for conv in $convenience; do
+	tmp_deplibs=
+	for test_deplib in $deplibs; do
+	  if test "$test_deplib" != "$conv"; then
+	    tmp_deplibs="$tmp_deplibs $test_deplib"
+	  fi
+	done
+	deplibs="$tmp_deplibs"
+	  done
 	  eval cmds=\"$archive_cmds\"
+	  deplibs="$save_deplibs"
 	fi
 	save_ifs="$IFS"; IFS='~'
 	for cmd in $cmds; do
