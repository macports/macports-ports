--- gtk/test/run-test.rb.orig	2008-06-14 20:36:00.000000000 +0900
+++ gtk/test/run-test.rb	2008-09-07 21:33:23.000000000 +0900
@@ -13,9 +13,9 @@
 require 'test/glib-test-init'
 
 [glib_base, atk_base, pango_base, gdk_pixbuf_base, gtk_base].each do |target|
-  if system("which make > /dev/null")
-    `make -C #{target.dump} > /dev/null` or exit(1)
-  end
+#  if system("which make > /dev/null")
+#    `make -C #{target.dump} > /dev/null` or exit(1)
+#  end
   $LOAD_PATH.unshift(File.join(target, "src"))
   $LOAD_PATH.unshift(File.join(target, "src", "lib"))
   $LOAD_PATH.unshift(File.join(target))
