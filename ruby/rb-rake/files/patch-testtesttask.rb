--- test/testtesttask.rb.orig	Thu Sep 16 21:36:22 2004
+++ test/testtesttask.rb	Thu Sep 16 21:36:57 2004
@@ -40,7 +40,7 @@
   def test_pattern
     ENV['TEST'] = nil
     tt = Rake::TestTask.new do |t|
-      t.pattern = '*.rb'
+      t.pattern = 'i*.rb'
     end
     assert_equal ['install.rb'], tt.file_list.to_a
   end
@@ -63,7 +63,7 @@
   def test_both_pattern_and_test_files
     tt = Rake::TestTask.new do |t|
       t.test_files = FileList['a.rb', 'b.rb']
-      t.pattern = '*.rb'
+      t.pattern = 'i*.rb'
     end
     assert_equal ['a.rb', 'b.rb', 'install.rb'], tt.file_list.to_a
   end
