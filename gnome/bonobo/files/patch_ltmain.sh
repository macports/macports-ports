--- ltmain.sh.org	Sat Jan 10 14:43:36 2004
+++ ltmain.sh	Sat Jan 10 14:46:26 2004
@@ -1727,7 +1727,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    # need_relink=yes
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
@@ -2888,6 +2888,11 @@
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
