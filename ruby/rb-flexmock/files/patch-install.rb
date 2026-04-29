--- install.rb.orig	2008-04-14 02:57:33.000000000 +0200
+++ install.rb	2008-04-14 03:00:12.000000000 +0200
@@ -13,7 +13,7 @@
 end
 
 $ruby = CONFIG['ruby_install_name']
-$sitedir = CONFIG["sitelibdir"]
+$sitedir = CONFIG["vendorlibdir"]
 
 unless $sitedir
   version = CONFIG["MAJOR"]+"."+CONFIG["MINOR"]

