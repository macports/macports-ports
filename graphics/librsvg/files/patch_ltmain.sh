--- ltmain.sh.org	Sun Jul 27 17:44:49 2003
+++ ltmain.sh	Sun Jul 27 17:45:27 2003
@@ -1777,7 +1777,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
