--- ltmain.sh.org	Thu Jul 24 21:42:51 2003
+++ ltmain.sh	Thu Jul 24 21:44:23 2003
@@ -4047,7 +4047,7 @@
 
 # Directory that this library needs to be installed in:
 libdir='$install_libdir'"
-	  if test "$installed" = no && test $need_relink = yes; then
+	  if test "$installed" = no && test $need_relink = no; then
 	    $echo >> $output "\
 relink_command=\"$relink_command\""
 	  fi
