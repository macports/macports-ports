--- framework/pre-install.rb.orig	2005-08-14 15:32:18.000000000 +0900
+++ framework/pre-install.rb	2005-08-14 15:32:46.000000000 +0900
@@ -3,7 +3,7 @@
 # strip symbols for diet of the object file.
 fwname = @config['framework-name']
 curdir = Dir.pwd
-Dir.chdir "build/#{fwname}.framework/Versions/Current"
+Dir.chdir "build/Default/#{fwname}.framework/Versions/Current"
 command "strip -x #{fwname}"
 Dir.chdir curdir
 
@@ -21,4 +21,4 @@
   command "mv '#{framework_path}' '#{backup_dir}/'"
 end
 command "mkdir -p '#{frameworks_dir}'"
-command "cp -R 'build/#{framework_name}' '#{framework_path}'"
+command "cp -R 'build/Default/#{framework_name}' '#{framework_path}'"
