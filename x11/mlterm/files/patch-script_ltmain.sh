--- script/ltmain.sh.orig	Sun Oct  5 07:10:06 2003
+++ script/ltmain.sh	Sun May 23 22:20:18 2004
@@ -1758,7 +1758,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+#	    need_relink=yes
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
