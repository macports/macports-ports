--- ltmain.sh.orig	Mon Sep  1 10:25:48 2003
+++ ltmain.sh	Mon Sep  1 10:26:21 2003
@@ -1772,7 +1772,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
