--- ../ruby-1.8.2.orig/instruby.rb	Wed Feb 25 04:16:30 2004
+++ instruby.rb	Tue Dec 28 21:59:04 2004
@@ -89,6 +89,8 @@
 archlibdir = with_destdir(CONFIG["archdir"])
 sitelibdir = with_destdir(CONFIG["sitelibdir"])
 sitearchlibdir = with_destdir(CONFIG["sitearchdir"])
+vendorlibdir = with_destdir(CONFIG["vendorlibdir"])
+vendorarchlibdir = with_destdir(CONFIG["vendorarchdir"])
 mandir = with_destdir(File.join(CONFIG["mandir"], "man"))
 configure_args = Shellwords.shellwords(CONFIG["configure_args"])
 enable_shared = CONFIG["ENABLE_SHARED"] == 'yes'
@@ -96,7 +98,7 @@
 lib = CONFIG["LIBRUBY"]
 arc = CONFIG["LIBRUBY_A"]
 
-makedirs [bindir, libdir, rubylibdir, archlibdir, sitelibdir, sitearchlibdir]
+makedirs [bindir, libdir, rubylibdir, archlibdir, sitelibdir, sitearchlibdir, vendorlibdir, vendorarchlibdir]
 
 ruby_bin = File.join(bindir, ruby_install_name)
 
