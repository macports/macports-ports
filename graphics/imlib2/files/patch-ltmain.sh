--- ltmain.sh.orig	Sun Sep  7 20:12:11 2003
+++ ltmain.sh	Sun May 23 20:59:37 2004
@@ -1716,7 +1716,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+#	    need_relink=yes
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
