--- orig-checksetup.pl	2006-09-06 11:44:36.000000000 -0400
+++ checksetup.pl	2006-09-06 15:05:45.000000000 -0400
@@ -664,7 +664,7 @@
 
 my $webservergroup_default;
 if ($^O !~ /MSWin32/i) {
-    $webservergroup_default = 'apache';
+    $webservergroup_default = 'www';
 } else {
     $webservergroup_default = '';
 }
