--- ltmain.sh.orig	Fri Nov 15 11:21:00 2002
+++ ltmain.sh	Fri Feb 28 16:23:53 2003
@@ -1742,7 +1742,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
