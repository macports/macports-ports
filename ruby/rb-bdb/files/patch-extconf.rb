--- extconf.rb.orig	2011-04-06 19:35:39 UTC
+++ extconf.rb
@@ -67,7 +67,7 @@ test: $(DLLIB)
    Dir.foreach('tests') do |x|
       next if /^\./ =~ x || /(_\.rb|~)$/ =~ x
       next if FileTest.directory?(x)
-      make.print "\t-#{CONFIG['RUBY_INSTALL_NAME']} tests/#{x}\n"
+      make.print "\t-#{RbConfig::CONFIG['ruby_install_name']} tests/#{x}\n"
    end
 ensure
    make.close
@@ -76,7 +76,7 @@ end
 subdirs.each do |subdir|
    STDERR.puts("#{$0}: Entering directory `#{subdir}'")
    Dir.chdir(subdir)
-   system("#{CONFIG['RUBY_INSTALL_NAME']} extconf.rb " + ARGV.join(" "))
+   system("#{RbConfig::CONFIG['ruby_install_name']} extconf.rb " + ARGV.join(" "))
    Dir.chdir("..")
    STDERR.puts("#{$0}: Leaving directory `#{subdir}'")
 end
