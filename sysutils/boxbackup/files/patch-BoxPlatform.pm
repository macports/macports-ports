--- infrastructure/BoxPlatform.pm.orig	Wed Dec 15 19:50:22 2004
+++ infrastructure/BoxPlatform.pm	Wed Dec 15 20:00:18 2004
@@ -78,7 +78,7 @@
 	close VERSION;
 	
 	# where to put the files
-	$install_into_dir = '/usr/local/bin';
+	$install_into_dir = $ENV{'PREFIX'}.'/bin';
 	
 	# if it's Darwin,
 	if($build_os eq 'Darwin')
@@ -97,6 +97,14 @@
 			print "Fink installation detected, will use headers and libraries\n";
 			$platform_compile_line_extra = '-I/sw/include ';
 			$platform_link_line_extra = '-L/sw/lib ';
+		}
+
+		# test for darwinports installation
+		if(-d $ENV{'PREFIX'}.'/var/db/dports')
+		{
+			print "DarwinPorts installation detected, will use headers and libraries\n";
+			$platform_compile_line_extra = '-I'.$ENV{'PREFIX'}.'/include ';
+			$platform_link_line_extra = '-L'.$ENV{'PREFIX'}.'/lib ';
 		}
 	}
 }
