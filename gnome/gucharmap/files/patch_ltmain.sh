--- ltmain.sh.org	Sat Jan 24 20:27:33 2004
+++ ltmain.sh	Sat Jan 24 20:29:35 2004
@@ -5174,7 +5174,7 @@
 
 # Directory that this library needs to be installed in:
 libdir='$install_libdir'"
-	  if test "$installed" = no && test "$need_relink" = yes; then
+	  if test "$installed" = no && test "$need_relink" = no; then
 	    $echo >> $output "\
 relink_command=\"$relink_command\""
 	  fi
