--- ltmain.sh.orig	Tue Apr  1 06:38:42 2003
+++ ltmain.sh	Fri Apr 25 15:51:34 2003
@@ -1777,7 +1777,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
