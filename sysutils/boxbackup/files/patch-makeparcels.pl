--- infrastructure/makeparcels.pl.orig	Wed Dec 15 20:09:45 2004
+++ infrastructure/makeparcels.pl	Wed Dec 15 20:11:09 2004
@@ -149,7 +149,7 @@
 			$name = $1;
 		}
 
-		print SCRIPT "install $name $install_into_dir\n";
+		print SCRIPT "install $name \$DESTDIR$install_into_dir\n";
 	}
 	
 	close SCRIPT;
