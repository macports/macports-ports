--- checksetup.pl.orig	Thu Sep 30 19:47:00 2004
+++ checksetup.pl	Thu Sep 30 19:47:43 2004
@@ -378,7 +378,7 @@
         }
     }
     print "\n";
-    exit;
+    exit 1;
 }
 
 }
@@ -596,7 +596,7 @@
 
 my $webservergroup_default;
 if ($^O !~ /MSWin32/i) {
-    $webservergroup_default = 'apache';
+    $webservergroup_default = 'www';
 } else {
     $webservergroup_default = '';
 }
@@ -1099,7 +1099,7 @@
            print "\n\n";
            print "The directory '$datadir/template' could not be removed. Please\n";
            print "remove it manually and rerun checksetup.pl.\n\n";
-           exit;
+           exit 1;
        }
     }
 
