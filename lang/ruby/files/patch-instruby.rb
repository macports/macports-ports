--- ../ruby-1.8.1.orig/instruby.rb	Thu Aug 21 05:36:27 2003
+++ instruby.rb	Thu Apr  1 15:49:33 2004
@@ -83,6 +83,8 @@
 archlibdir = $destdir+CONFIG["archdir"]
 sitelibdir = $destdir+CONFIG["sitelibdir"]
 sitearchlibdir = $destdir+CONFIG["sitearchdir"]
+vendorlibdir = $destdir+CONFIG["vendorlibdir"]
+vendorarchlibdir = $destdir+CONFIG["vendorarchdir"]
 mandir = File.join($destdir+CONFIG["mandir"], "man")
 configure_args = Shellwords.shellwords(CONFIG["configure_args"])
 enable_shared = CONFIG["ENABLE_SHARED"] == 'yes'
@@ -90,7 +92,7 @@
 lib = CONFIG["LIBRUBY"]
 arc = CONFIG["LIBRUBY_A"]
 
-makedirs [bindir, libdir, rubylibdir, archlibdir, sitelibdir, sitearchlibdir]
+makedirs [bindir, libdir, rubylibdir, archlibdir, sitelibdir, sitearchlibdir, vendorlibdir, vendorarchlibdir]
 
 ruby_bin = File.join(bindir, ruby_install_name)
 
