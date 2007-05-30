--- data/msfweb/config/environment.rb	2007-03-25 16:45:17.000000000 -0700
+++ data/msfweb/config/environment.rb	2007-05-29 14:57:59.000000000 -0700
@@ -14,7 +14,7 @@
 end
 
 
-msfbase = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
+msfbase = File.symlink?(__FILE__) ? File.join(File.expand_path(File.dirname(File.readlink(__FILE__)), File.dirname(__FILE__)), File.basename(__FILE__)) : __FILE__
 $:.unshift(File.join(File.dirname(msfbase), '..', '..', '..', 'lib'))
 
 require 'rex'
