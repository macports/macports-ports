--- ../ruby-1.8.1.orig/lib/mkmf.rb	Thu Dec 18 15:01:04 2003
+++ lib/mkmf.rb	Fri Apr  2 12:04:34 2004
@@ -45,6 +45,9 @@
 $sitedir = CONFIG["sitedir"]
 $sitelibdir = CONFIG["sitelibdir"]
 $sitearchdir = CONFIG["sitearchdir"]
+$vendordir = CONFIG["vendordir"]
+$vendorlibdir = CONFIG["vendorlibdir"]
+$vendorarchdir = CONFIG["vendorarchdir"]
 
 $extmk = /extmk\.rb/ =~ $0
 $mswin = /mswin/ =~ RUBY_PLATFORM
@@ -734,6 +737,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 RUBY = #{$ruby}
 RM = $(RUBY) -run -e rm -- -f
