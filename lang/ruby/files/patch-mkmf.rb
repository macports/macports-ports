--- ../ruby-1.8.2.orig/lib/mkmf.rb	Fri Sep 17 23:56:36 2004
+++ lib/mkmf.rb	Tue Dec 28 21:52:38 2004
@@ -47,6 +47,9 @@
 $sitedir = CONFIG["sitedir"]
 $sitelibdir = CONFIG["sitelibdir"]
 $sitearchdir = CONFIG["sitearchdir"]
+$vendordir = CONFIG["vendordir"]
+$vendorlibdir = CONFIG["vendorlibdir"]
+$vendorarchdir = CONFIG["vendorarchdir"]
 
 $mswin = /mswin/ =~ RUBY_PLATFORM
 $bccwin = /bccwin/ =~ RUBY_PLATFORM
@@ -751,6 +754,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = #{($nmake && !$extmk && !$configure_args.has_key?('--ruby')) ? '$(ruby:/=\)' : '$(ruby)'}
