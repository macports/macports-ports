--- ltmain.sh.org	Sun May  2 19:55:51 2004
+++ ltmain.sh	Sun May  2 19:58:13 2004
@@ -1770,10 +1770,10 @@
 	    continue
 	  fi
 
-	  if test "$installed" = no; then
-	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
-	  fi
+	  #if test "$installed" = no; then
+	    #notinst_deplibs="$notinst_deplibs $lib"
+	    #need_relink=yes
+	  #fi
 
 	  if test -n "$old_archive_from_expsyms_cmds"; then
 	    # figure out the soname
