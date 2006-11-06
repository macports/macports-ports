--- instruby.rb.orig	2005-07-05 07:45:33.000000000 -0700
+++ instruby.rb	2006-01-08 08:29:51.000000000 -0800
@@ -99,6 +99,8 @@
 archlibdir = with_destdir(CONFIG["archdir"])
 sitelibdir = with_destdir(CONFIG["sitelibdir"])
 sitearchlibdir = with_destdir(CONFIG["sitearchdir"])
+vendorlibdir = with_destdir(CONFIG["vendorlibdir"])
+vendorarchlibdir = with_destdir(CONFIG["vendorarchdir"])
 mandir = with_destdir(File.join(CONFIG["mandir"], "man"))
 configure_args = Shellwords.shellwords(CONFIG["configure_args"])
 enable_shared = CONFIG["ENABLE_SHARED"] == 'yes'
@@ -106,7 +108,7 @@
 lib = CONFIG["LIBRUBY"]
 arc = CONFIG["LIBRUBY_A"]
 
-makedirs [bindir, libdir, rubylibdir, archlibdir, sitelibdir, sitearchlibdir]
+makedirs [bindir, libdir, rubylibdir, archlibdir, sitelibdir, sitearchlibdir, vendorlibdir, vendorarchlibdir]
 
 install?(:bin) do
   ruby_bin = File.join(bindir, ruby_install_name)
