--- work/destroot/opt/local/lib/ruby/gems/1.8/gems/Technorati-Ruby-0.1.0/technorati.rb	2006-11-25 05:18:37.000000000 +0900
+++ technorati.rb	2006-11-25 05:19:44.000000000 +0900
@@ -481,6 +481,7 @@
     args = ["key=#@key", "url=#{url.uri_escape}"]
     ret = get('bloginfo', '/bloginfo?' << args.compact.join('&'))
     ret.delete('items')
+    ret
   end
 
 end
