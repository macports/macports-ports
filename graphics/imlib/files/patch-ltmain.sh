--- ltmain.sh.orig	Mon Mar 25 09:45:29 2002
+++ ltmain.sh	Sun May 23 19:52:24 2004
@@ -1760,7 +1760,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+#	    need_relink=yes
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
