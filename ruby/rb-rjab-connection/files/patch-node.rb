--- lib/rjab/conn/node.rb	Mon Jan 21 20:21:24 2002
+++ ../rjab-connection.jdp/src/lib/rjab/conn/node.rb	Mon Jan 19 15:20:38 2004
@@ -1,3 +1,5 @@
+require 'rexml/document'
+
 module Jabber
 
 class Node < REXML::Document
