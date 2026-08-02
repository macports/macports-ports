--- src/features.rb.orig	2011-04-06 19:35:39 UTC
+++ src/features.rb
@@ -813,7 +813,6 @@
 begin
    conftest = CONFTEST_C.dup
    class Object
-      remove_const('CONFTEST_C')
    end
 
    CONFTEST_C = 'conftest.cxx'
@@ -878,7 +877,6 @@
 
 ensure
    class Object
-      remove_const('CONFTEST_C')
    end
 
    CONFTEST_C = conftest
