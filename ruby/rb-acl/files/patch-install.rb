--- install.rb.orig	Thu Dec 30 09:12:47 2004
+++ install.rb	Thu Dec 30 09:13:04 2004
@@ -41,7 +41,7 @@
     site_libdir = $:.find {|x| x =~ /site_ruby$/}
     if !site_libdir
       site_libdir = File.join(@libdir, "site_ruby")
-    elsif site_libdir !~ Regexp.quote(@version)
+    elsif site_libdir !~ Regexp.new(Regexp.quote(@version))
       site_libdir = File.join(site_libdir, @version)
     end
     site_libdir
