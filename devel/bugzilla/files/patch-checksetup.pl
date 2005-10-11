--- checksetup.pl	2005-09-27 19:16:55.000000000 +0200
+++ checksetup.pl	2005-10-11 13:55:12.000000000 +0200
@@ -442,7 +442,7 @@
         }
     }
     print "\n";
-    exit;
+    exit 1;
 }
 
 }
@@ -661,7 +661,7 @@
 
 my $webservergroup_default;
 if ($^O !~ /MSWin32/i) {
-    $webservergroup_default = 'apache';
+    $webservergroup_default = 'www';
 } else {
     $webservergroup_default = '';
 }
