--- lib/rjab/conn/xmllistener.rb	Mon Jan 21 17:28:38 2002
+++ ../rjab-connection.jdp/src/lib/rjab/conn/xmllistener.rb	Mon Jan 19 15:20:38 2004
@@ -8,7 +8,8 @@
     #attr.each { |k,v| puts "  K/V: #{k} / #{v}" }
 
     # convert attributes array into hash for name-based lookup
-    h_attr = Hash[ *attr.flatten ] 
+    #h_attr = Hash[ *attr.flatten ] 
+    h_attr = attr
 
     if name == 'stream:stream'
       @currnode = Node.new(name)
