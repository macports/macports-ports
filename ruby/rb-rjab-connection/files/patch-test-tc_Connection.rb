--- orig_src/test/tc_Connection.rb	Wed Dec 31 16:00:00 1969
+++ tests/tc_Connection.rb	Mon Jan 19 15:20:38 2004
@@ -0,0 +1,419 @@
+##
+# $Id: patch-test-tc_Connection.rb,v 1.1 2004/02/06 04:21:11 rshaw Exp $
+#
+
+require 'test/unit'
+require 'test/unit/mock'
+
+require 'rjab/connection'
+
+require 'socket'
+
+module Jabber
+    class Connection
+        def get_id
+            '1234'
+        end
+    end
+end
+
+class TestJabberConnection < Test::Unit::TestCase
+
+    def setup
+        debug = false
+        @server = 'localhost'
+
+        # for authentication tests
+        @user = 'foobar'
+        @pass = 'passwd'
+        @resource = 'testing'
+        
+        # @jc is a client (default behavior)
+        @jc = Jabber::Connection.new(@server)
+
+        @mockSock = Test::Unit::MockObject(TCPSocket).new(@server, 5222)
+    end
+
+    def teardown
+        @jc = nil
+    end
+
+    def test_new
+        assert_equal Jabber::Connection, @jc.class, "Jabber::Connection class exists"
+   end
+
+    def test_connect_disconnect
+        # Setup mockSock to require a send and a recv...
+        #   Have send make sure we got the stream_header
+        #   Have recv give back a reasonable answer from the 'jabber' server
+        #
+        @mockSock.setReturnValues(:write => Proc::new { |q|
+            eq = "<?xml version='1.0'?><stream:stream to='#{@server}'"
+            eq += " xmlns='jabber:client'"
+            eq += " xmlns:stream='http://etherx.jabber.org/streams'>"
+            if not eq == q
+                raise RuntimeError, "wrong query sent\n\texpected: #{eq}\n\tgot#{q}"
+            else
+                return q.length
+            end
+        })
+
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='3F7D916A' xmlns='jabber:client' from='jabber.hf.mxim.com'>} \
+            ]
+        )
+        @mockSock.setCallOrder( :write, :recv )
+        @mockSock.activate
+
+        assert_equal false, @jc.connected?, "not connected yet"
+        assert_equal true, @jc.connect(@mockSock), "connect()"
+        assert_equal true, @jc.connected?, "connected now"
+
+        @mockSock.verify
+        @mockSock.reset
+
+        # A call to connect() when already connected should just not
+        # try to connect again...
+        @mockSock.setCallOrder()
+        @mockSock.strictCallOrder = true
+        @mockSock.activate
+
+        @jc.connect(@mockSock)
+
+        @mockSock.verify
+        @mockSock.reset
+        if @mockSock.strictCallOrder?
+            @mockSock.strictCallOrder = false
+        end
+
+        @mockSock.setReturnValues(:write => Proc::new { |q|
+            eq = "</stream:stream>"
+            if not eq == q
+                return 0
+            else
+                return q.length
+            end
+        })
+        @mockSock.setCallOrder( :write, :shutdown )
+        @mockSock.activate
+
+        assert_equal false, @jc.disconnect(), "disconnect()"
+        assert_equal false, @jc.connected?, "disconnected"
+
+        @mockSock.verify
+        @mockSock.reset
+    end
+
+    def test_auth_wo_connect
+        # Auth w/o connect should raise error
+        assert_raises(RuntimeError, "need connect before auth()") { ||
+            @jc.auth(@user, @pass, @resource)
+        }
+    end
+
+    def test_auth_zerok
+        # Connect using mockSock
+        @mockSock.setReturnValues(:write => [12])
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='3F7D916A' xmlns='jabber:client' from='jabber.hf.mxim.com'>} \
+            ]
+        )
+        @mockSock.setCallOrder( :write, :recv )
+        @mockSock.activate
+        @jc.connect(@mockSock)
+        @mockSock.verify
+        @mockSock.reset
+
+
+        # Now authenticate ...
+        #
+        write_callno = 0
+
+        @mockSock.setReturnValues(:write => Proc::new { |q|
+            if q == "</stream:stream>"
+                return 0
+            end
+
+            #if (md = /id='(rjab_[0-9]+)'/.match(q))
+            #    id = md[1]
+            #else
+            #    id = 0
+            #end
+
+            case write_callno
+            when 0
+                eq = "<iq type='get' id='1234'><query xmlns='jabber:iq:auth'>"
+                eq += "<username>"
+                eq += "foobar</username></query></iq>"
+            when 1
+                eq = "<iq type='set' id='1234'><query xmlns='jabber:iq:auth'>"
+                eq += "<username>foobar</username>"
+                eq += "<hash>d3d6cc6b1179aa8a66e05e4e9f95b6aa5a2e47eb"
+                eq += "</hash><resource>testing</resource></query></iq>"
+            else
+                eq = "Unexpected call number: #{write_callno}"
+            end
+            write_callno += 1
+
+            if eq == q
+                return q.length
+            else
+                raise RuntimeError, \
+                    "wrong query sent\n\texpected: #{eq}\n\tgot#{q}"
+            end
+
+        })
+
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<iq type='result' id='1234'><query xmlns='jabber:iq:auth'><username>foobar</username><password/><digest/><sequence>446</sequence><token>3D0F5885</token><resource/></query></iq>}, \
+            %q{<iq type='result' id='1234'/>} \
+            ]
+        )
+
+        @mockSock.setCallOrder( :write, :recv, :write, :recv )
+        @mockSock.activate
+        assert_equal true, @jc.auth(@user, @pass, @resource), "auth success"
+        @mockSock.verify
+        @mockSock.reset
+
+    end
+
+    def test_auth_digest
+
+        # Connect using mockSock
+        @mockSock.setReturnValues(:write => [12])
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='3F7D916A' xmlns='jabber:client' from='jabber.hf.mxim.com'>} \
+            ]
+        )
+        @mockSock.setCallOrder( :write, :recv )
+        @mockSock.activate
+        @jc.connect(@mockSock)
+        @mockSock.verify
+        @mockSock.reset
+
+
+        # Now authenticate ...
+        write_callno = 0
+        @mockSock.setReturnValues(:write => Proc::new { |q|
+            if q == "</stream:stream>"
+                return 0
+            end
+
+            #if (md = /id='(rjab_[0-9]+)'/.match(q))
+            #    id = md[1]
+            #else
+            #    id = 0
+            #end
+
+            case write_callno
+            when 0
+                eq = "<iq type='get' id='1234'><query xmlns='jabber:iq:auth'>"
+                eq += "<username>"
+                eq += "foobar</username></query></iq>"
+
+            when 1
+                eq = "<iq type='set' id='1234'><query xmlns='jabber:iq:auth'>"
+                eq += "<username>foobar</username>"
+                eq += "<digest>daf38c983a261d55c77632438182c72d8678f657"
+                eq += "</digest><resource>testing</resource></query></iq>"
+            else
+                eq = "Unexpected call number: #{write_callno}"
+            end
+            write_callno += 1
+
+            if eq == q
+                return q.length
+            else
+                raise RuntimeError, \
+                    "wrong query sent\n\texpected: #{eq}\n\tgot#{q}"
+            end
+
+        })
+
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<iq type='result' id='1234'><query xmlns='jabber:iq:auth'><username>foobar</username><password/><digest/><sequence>446</sequence><resource/></query></iq>}, \
+            %q{<iq type='result' id='1234'/>} \
+            ]
+        )
+
+        @mockSock.setCallOrder( :write, :recv, :write, :recv )
+        @mockSock.activate
+        assert_equal true, @jc.auth(@user, @pass, @resource), "auth success"
+        @mockSock.verify
+        @mockSock.reset
+
+    end
+
+    def test_auth_passwd
+
+        # Connect using mockSock
+        @mockSock.setReturnValues(:write => [12])
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='3F7D916A' xmlns='jabber:client' from='jabber.hf.mxim.com'>} \
+            ]
+        )
+        @mockSock.setCallOrder( :write, :recv )
+        @mockSock.activate
+        @jc.connect(@mockSock)
+        @mockSock.verify
+        @mockSock.reset
+
+
+        # Now authenticate ...
+        write_callno = 0
+        @mockSock.setReturnValues(:write => Proc::new { |q|
+            if q == "</stream:stream>"
+                return 0
+            end
+
+            if (md = /id='(rjab_[0-9]+)'/.match(q))
+                id = md[1]
+            else
+                id = 0
+            end
+
+            case write_callno
+            when 0
+                eq = "<iq type='get' id='1234'><query xmlns='jabber:iq:auth'>"
+                eq += "<username>"
+                eq += "foobar</username></query></iq>"
+
+            when 1
+                eq = "<iq type='set' id='1234'><query xmlns='jabber:iq:auth'>"
+                eq += "<username>foobar</username>"
+                eq += "<password>passwd</password>"
+                eq += "<resource>testing</resource></query></iq>"
+            else
+                eq = "Unexpected call number: #{write_callno}"
+            end
+            write_callno += 1
+
+            if eq == q
+                return q.length
+            else
+                raise RuntimeError, \
+                    "wrong query sent\n\texpected: #{eq}\n\tgot: #{q}"
+            end
+
+        })
+
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<iq type='result' id='1234'><query xmlns='jabber:iq:auth'><username>foobar</username><password/><sequence>446</sequence><resource/></query></iq>}, \
+            %q{<iq type='result' id='1234'/>} \
+            ]
+        )
+
+        @mockSock.setCallOrder( :write, :recv, :write, :recv )
+        @mockSock.activate
+        assert_equal true, @jc.auth(@user, @pass, @resource), "auth success"
+        @mockSock.verify
+        @mockSock.reset
+
+    end
+
+    def test_write
+        # Connect
+        @mockSock.setReturnValues(:write => [12])
+        @mockSock.setReturnValues(:recv => [ \
+            %q{<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='3F7D916A' xmlns='jabber:client' from='jabber.hf.mxim.com'>} \
+            ]
+        )
+        @mockSock.setCallOrder( :write, :recv )
+        @mockSock.activate
+        @jc.connect(@mockSock)
+        @mockSock.verify
+        @mockSock.reset
+
+        # skip authentication, it doesn't change @jc state :0
+        # go straight to testing write() method
+
+        @mockSock.setReturnValues(:write => Proc::new { |q|
+            case q
+            when /presence/
+                eq = "<presence/>"
+
+            when /message/
+                eq = "<message to='foo@bar.com'><body>hello</body></message>"
+            else
+                raise RuntimeError, "unexpected query sent:\n\t#{q}"
+            end
+
+            if eq == q.to_s
+                return q.length
+            else
+                raise RuntimeError, "wrong query sent\n\texpected: #{eq}\n\tgot#{q}"
+            end
+        })
+
+        @mockSock.setCallOrder( :write, :write )
+        @mockSock.activate
+        assert_equal 11, @jc.write("<presence/>"), ""
+        msg = Jabber::Node.new_message('foo@bar.com','hello')
+        assert_equal 11, @jc.write("<presence/>"), "write an XML string"
+        assert_equal 54, @jc.write(msg), "write a node"
+        @mockSock.verify
+        @mockSock.reset
+
+   end
+
+   def test_handlers
+
+       # 'Connect' to use mock socket...
+       @mockSock.setReturnValues(:write => [12])
+       @mockSock.setReturnValues(:recv => [ \
+           %q{<?xml version='1.0'?><stream:stream xmlns:stream='http://etherx.jabber.org/streams' id='3F7D916A' xmlns='jabber:client' from='jabber.hf.mxim.com'>} \
+           ]
+       )
+       @mockSock.setCallOrder( :write, :recv )
+       @mockSock.activate
+       @jc.connect(@mockSock)
+       @mockSock.verify
+       @mockSock.reset
+
+       # register some handlers
+
+       h1_called = false
+       h2_called = false
+       h3_called = false
+       h4_called = false
+       h5_called = false
+       @jc.register_handler('iq') {h1_called = true}
+       @jc.register_handler('iq') {h2_called = true; Jabber::NS::R_HANDLED}
+       @jc.register_handler('iq') {h3_called = true}
+       @jc.register_handler('message') {h4_called = true}
+       @jc.register_handler('presence') {h5_called = true}
+
+       # give process() some stuff to do...
+       @mockSock.setReturnValues(:recv => [ \
+            %q{<iq type='result' id='4'/><message id='3'/>}, \
+            %q{<presence/>} \
+           ]
+       )
+
+       @mockSock.activate
+
+       @jc.process(1)
+       assert_equal true, h1_called, "iq hanlder 1 called"
+       assert_equal true, h2_called, "iq hanlder 2 called"
+       assert_equal false, h3_called, "iq hanlder 3 not called"
+       assert_equal true, h4_called, "message hanlder 4 called"
+       assert_equal false, h5_called, "presence hanlder 5 not called"
+
+       h1_called = false
+       h2_called = false
+       h3_called = false
+       h4_called = false
+       h5_called = false
+       @jc.process(1)
+       assert_equal false, h1_called, "iq hanlder 1 not called"
+       assert_equal false, h2_called, "iq hanlder 2 not called"
+       assert_equal false, h3_called, "iq hanlder 3 not called"
+       assert_equal false, h4_called, "message hanlder 4 not called"
+       assert_equal true, h5_called, "presence hanlder 5 called"
+
+       @mockSock.verify
+       @mockSock.reset
+   end
+
+end
