--- ltmain.sh.org	Wed Feb  4 18:18:18 2004
+++ ltmain.sh	Wed Feb  4 18:18:53 2004
@@ -1772,7 +1772,7 @@
 
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    #need_relink=yes
 	  fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
