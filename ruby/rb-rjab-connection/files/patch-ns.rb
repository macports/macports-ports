--- lib/rjab/conn/ns.rb	Mon Jan 21 17:28:38 2002
+++ ../rjab-connection.jdp/src/lib/rjab/conn/ns.rb	Mon Jan 19 15:20:38 2004
@@ -46,6 +46,9 @@
     IQ_SET        = 'set'
     IQ_ERROR      = 'error'
     IQ_RESULT     = 'result'
+
+    # flags
+    R_HANDLED     = '!jabber-connection-handled!'
     
     # other non-namespace constants
     #STREAM_HEAD   = "<?xml version=\'1.0\'?><stream:stream to=\'#{@server}\' xmlns=\'jabber:client\' xmlns:stream=\'http://etherx.jabber.org/streams\'>"
