--- tools/module_license.rb	2007-03-25 16:45:06.000000000 -0700
+++ tools/module_license.rb	2007-05-29 14:57:38.000000000 -0700
@@ -3,7 +3,7 @@
 # This script lists each module by its licensing terms
 #
 
-msfbase = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
+msfbase = File.symlink?(__FILE__) ? File.join(File.expand_path(File.dirname(File.readlink(__FILE__)), File.dirname(__FILE__)), File.basename(__FILE__)) : __FILE__
 $:.unshift(File.join(File.dirname(msfbase), '..', 'lib'))
 
 require 'rex'
