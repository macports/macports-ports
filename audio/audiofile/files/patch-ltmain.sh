--- ltmain.sh	Thu Oct 25 22:12:17 2001
+++ ltmain.sh	Fri Feb  1 16:11:59 2002
@@ -2894,7 +2894,12 @@
 	if test -n "$export_symbols" && test -n "$archive_expsym_cmds"; then
 	  eval cmds=\"$archive_expsym_cmds\"
 	else
+	  save_deplibs="$deplibs"
+	  for conv in $convenience; do
+	    deplibs="${deplibs%$conv*} ${deplibs#*$conv}"
+	  done
 	  eval cmds=\"$archive_cmds\"
+	  deplibs="$save_deplibs"
 	fi
 	save_ifs="$IFS"; IFS='~'
 	for cmd in $cmds; do
