--- orig_src/test/tc_Node.rb	Wed Dec 31 16:00:00 1969
+++ tests/tc_Node.rb	Mon Jan 19 15:20:38 2004
@@ -0,0 +1,38 @@
+##
+# $Id: patch-test-tc_Node.rb,v 1.1 2004/02/06 04:21:11 rshaw Exp $
+#
+
+require 'test/unit'
+
+require 'rjab/conn/node'
+
+class TestNode < Test::Unit::TestCase
+    def setup
+    end
+
+    def teardown
+    end
+
+    def test_new
+        # test node create with string arg
+        node = Jabber::Node.new('abc')
+        str = ""
+        node.write str, -1
+        assert_equal '<abc/>', str, 'Node.new(string)'
+        
+        # test node create with XML arg
+        node = Jabber::Node.new('<cde/>')
+        str = ""
+        node.write str, -1
+        assert_equal '<cde/>', str, 'Node.new(xml)'
+    end
+
+    def test_new_message
+        node = Jabber::Node.new_message('foo@bar', 'body')
+        str = ""
+        node.write str, -1
+        assert_equal "<message to='foo@bar'><body>body</body></message>", \
+            str, 'Node.new_massage()'
+    end
+
+end
