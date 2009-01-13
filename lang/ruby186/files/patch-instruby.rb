--- instruby.rb.orig	2007-03-15 13:25:14.000000000 +0900
+++ instruby.rb	2007-03-15 13:31:29.000000000 +0900
@@ -162,6 +162,8 @@
 archlibdir = CONFIG["archdir"]
 sitelibdir = CONFIG["sitelibdir"]
 sitearchlibdir = CONFIG["sitearchdir"]
+vendorlibdir = CONFIG["vendorlibdir"]
+vendorarchlibdir = CONFIG["vendorarchdir"]
 mandir = File.join(CONFIG["mandir"], "man")
 configure_args = Shellwords.shellwords(CONFIG["configure_args"])
 enable_shared = CONFIG["ENABLE_SHARED"] == 'yes'
@@ -202,7 +204,7 @@
   extout = "#$extout"
   install?(:ext, :arch, :'ext-arch') do
     puts "installing extension objects"
-    makedirs [archlibdir, sitearchlibdir]
+    makedirs [archlibdir, sitearchlibdir, vendorarchlibdir]
     if noinst = CONFIG["no_install_files"] and noinst.empty?
       noinst = nil
     end
@@ -210,7 +212,7 @@
   end
   install?(:ext, :comm, :'ext-comm') do
     puts "installing extension scripts"
-    makedirs [rubylibdir, sitelibdir]
+    makedirs [rubylibdir, sitelibdir, vendorlibdir]
     install_recursive("#{extout}/common", rubylibdir)
   end
 end
