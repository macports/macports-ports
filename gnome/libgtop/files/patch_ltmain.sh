--- ltmain.sh.org	Tue Aug 26 21:08:13 2003
+++ ltmain.sh	Tue Aug 26 21:09:38 2003
@@ -2211,7 +2211,7 @@
 	   { test "$prefer_static_libs" = no || test -z "$old_library"; }; then
 	  if test "$installed" = no; then
 	    notinst_deplibs="$notinst_deplibs $lib"
-	    need_relink=yes
+	    need_relink=no
 	  fi
 	  # This is a shared library
 	
