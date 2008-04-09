--- install.rb.orig	2007-11-23 12:36:57.000000000 +0100
+++ install.rb	2008-04-09 23:09:29.000000000 +0200
@@ -6,12 +6,9 @@
 
 include Config
 
-bindir = CONFIG["bindir"]
-cd 'bin' do
-  filename = 'edit_json.rb'
-  #install(filename, bindir)
-end
-sitelibdir = CONFIG["sitelibdir"]
+DESTROOT = ARGV[0] || String.new
+
+sitelibdir = DESTROOT + CONFIG["vendorlibdir"]
 cd 'lib' do
   install('json.rb', sitelibdir)
   mkdir_p File.join(sitelibdir, 'json')
