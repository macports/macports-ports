--- ltmain.sh.org	Fri Nov 28 17:38:47 2003
+++ ltmain.sh	Fri Nov 28 17:40:13 2003
@@ -1772,7 +1772,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
