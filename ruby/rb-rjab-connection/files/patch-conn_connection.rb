--- lib/rjab/conn/connection.rb	Mon Jan 21 20:49:48 2002
+++ ../rjab-connection.jdp/src/lib/rjab/conn/connection.rb	Wed Jan 28 09:46:41 2004
@@ -6,31 +6,32 @@
 #  Connection::Client and Connection::Component
 # 
 
-require 'sha1'
-require 'socket'
+module Jabber
 
-require 'rjab/conn/node'
-require 'rjab/conn/ns'
-require 'rjab/conn/xmllistener'
+    class Connection
 
-module Jabber
+        require 'rjab/conn/node'
+        require 'rjab/conn/ns'
+        require 'rjab/conn/xmllistener'
+
+        require 'digest/sha1'
+
+        require 'socket'
 
-class Connection
   include Jabber::NS
   include Jabber::XMLListener
 
-  def initialize(server, port, ns, localname, log=nil)
+        def initialize(server = 'localhost', port = 5222, \
+                ns = NS_CLIENT, localname = 'local', log=nil)
     # instance vars instantiated at object creation
-    @server, @port = server, port || 5222
-    @ns = ns || NS_CLIENT
-    @localname = localname
-    @log = log
+            @server, @port, @ns, @localname, @log = server, port, ns, \
+                localname, log
     
     # instance vars instantiated later in program
     @answer, @ask_id = nil
     @beatcount = 0
     @connected = false
-    @handlers = []
+            @handlers = {}
     
     # vars for XMLListener
     @depth = 1
@@ -39,40 +40,46 @@
     @confirmedhost, @streamid, @errortext  = ""
   end
   
-  def connect
-    # FIXME: wrap in begin / rescue block
-    @socket = TCPSocket.open(@server, @port)
-    self.write(stream_header)
-    self.read
-    @connected = true
+        def ask(node)
+            unless @ask_id = node.root.attributes['id']
+                debug("Ask: no ID - getting one")
+                @ask_id = get_id
+                node.root.attributes['id'] = @ask_id
   end
+            debug("Ask: id = #{@ask_id}")
 
-  def disconnect
-    self.write(STREAM_END)
-    @socket.shutdown
-  end
+            str = ""
+            node.write str, -1
+            _write str
   
-  def process(time)
-    if IO.select([@socket], nil, nil, time)
-      return self.read
-    end
+            while (@answer == nil)
+                debug("Ask: waiting for answer")
+                process(1)
   end
 
-  def parse_data(source)                        # TODO?: subclass REXML::Source    
-    REXML::Document.parse_stream(source, self)  #  so that it works properly with
-  end                                           #  sockets
+            answer = @answer
+            @answer = nil
+            debug("Ask: got answer") # FIXME: write out XML of answer
+            return answer
+        end
 
   def auth(*args)
+            raise_unless_connected
+
     # FIXME: wrap in begin/rescue block
-    if @ns == NS_CLIENT
-      @user, @pass = args[0], args[1]
-      @resource = args[2]
+            case @ns
+            when NS_CLIENT
+                if args.length < 3
+                    raise ArgumentError, \
+                        "Wrong number of arguments (#{auth.length} for 3)"
+                end
+                user, pass, resource = args[0..2]
 
       auth_node = Node.new('iq')
       auth_node.root.attributes['type'] = IQ_GET
       query = auth_node.root.add_element('query')
       query.attributes['xmlns'] = NS_AUTH
-      query.add_element('username').text = @user
+                query.add_element('username').text = user
 
       get_result = ask(auth_node)
 
@@ -80,145 +87,189 @@
       auth_node.root.attributes['id'] = get_id
       
       if get_result.root.elements['token']
-	hash = SHA1.new(@pass).hexdigest
+                    hash = sha1(pass)
 	seq = get_result.root.elements['sequence'].text.to_i
 	token = get_result.root.elements['token'].text
-	hash = SHA1.new(hash + token).hexdigest
-	seq.downto(1) { hash = SHA1.new(hash).hexdigest }
+                    hash = sha1(hash + token)
+                    seq.downto(1) { hash = sha1(hash) }
 	query.add_element('hash').text = hash
+
       elsif get_result.root.elements['digest']
-	query.add_element('digest').text = SHA1.new(@streamid + @pass).hexdigest
+                    query.add_element('digest').text = sha1(@streamid + pass)
+
       elsif get_result.root.elements['password']
 	debug("auth: plaintext supported")
-	query.add_element('password').text = @pass
+                    query.add_element('password').text = pass
       else
-	debug("auth: no authentication methods supported...")
-	raise
+                    raise RuntimeError, "No authentication methods supported."
       end
       
-      query.add_element('resource').text = @resource
+                query.add_element('resource').text = resource
      
       set_result = ask(auth_node)
-      unless (set_result.root.attributes['type'] == IQ_RESULT)
-	puts "AUTH FAILED!!!"
+
+                if (set_result.root.attributes['type'] != IQ_RESULT)
 	disconnect
-	raise
-      else
-	puts "Auth succeeded!!!"
-      end
-    elsif @ns == NS_ACCEPT
-      @secret = args[0]
+                    raise RuntimeError, "Authentication failed."
     end
+
+            when NS_ACCEPT
+                raise NotImplementedError, "Component support not ready"
   end
 
-  def stream_header
-    # FIXME: find a way to move this crap into Jabber::NS and still allow for 
-    #  variable substitution
-    header = "<?xml version=\'1.0\'?><stream:stream to=\'#{@server}\' xmlns=\'jabber:client\' xmlns:stream=\'http://etherx.jabber.org/streams\'>"
+            true
   end
 
-  def send(data)
-    # FIXME: compact method
-    if data.instance_of? Node
-      str = ""
-      data.write str, -1
-      self.write str
+        def connect(sock=nil) 
+            # FIXME: wrap in begin / rescue block
+            if not @connected
+                if defined? Test::Unit::TestCase
+                    @socket = sock
     else
-      self.write data
+                    @socket = TCPSocket.open(@server, @port)
+                end
+                _write(stream_header)
+                read()
+                @connected = true
     end
+            @connected
   end
 
-  def write(data)
-    debug("Write: #{data}") 
-    @socket.write(data)
+        def disconnect
+            _write(STREAM_END)
+            @socket.shutdown
+            @connected = false
   end
   
-  def read
-    recieved = ""
-    while data = @socket.recv(1024)
-      recieved += data
-      break if data != 1024
+        def process(time = 0)
+            if defined? Test::Unit::TestCase
+                def select(r, w, e, t)
+                    return [r, w, e, t]
+                end
+            end
+            handle = select([@socket], nil, nil, time)
+            if not handle.nil? and handle[0][0] = @socket
+                return read
+            end
+            return true
     end
     
-    debug("Read: #{recieved}")
+        def register_handler(tag, &handler)
+            debug("Register_handler: tag type: #{tag}")
+            if not @handlers.has_key?(tag)
+                @handlers[tag] = []
+            end
+            @handlers[tag].push(handler)
+        end
     
-    # ewww... grotesque
-    if recieved =~ /<stream/ 
-      debug("Read: munging so REXML is happy")
-      recieved.chop!.concat('/>')
+        def write(data)
+            raise_unless_connected
+
+            if data.instance_of? Node
+                str = ""
+                data.write str, -1
+                _write str
+            else
+                _write data
+            end
     end
 
-    parse_data(recieved)
-    return recieved
+        def connected?
+            @connected
   end
 
-  def log(log_string)
-    if @log then puts "LOG: #{log_string}" end
+        if defined? Test::Unit::TestCase
+            def set_server(server)
+                @server = server
+                @server
+            end
   end
   
+        private
+
   def debug(debug_string)
     if $DEBUG then puts "DEBUG: #{debug_string}" end
   end
  
-  def last_error; end
-
   def dispatch(node)
     debug("dispatching: #{node.root.name}")
 
-    if @ask_id != nil
+            if not @ask_id.nil?
+                debug("ask_id: #{@ask_id}")
+                if @ask_id == node.root.attributes['id']
       @ask_id = nil
       @answer = node
     end
+            end
     
-    @handlers.each do |name, obj|
-      if name == node.root.name
-	obj.call(node)
+            if @handlers.has_key?(node.root.name)
+                @handlers[node.root.name].each { |handler|
+                    parcel = handler.call(node, parcel) || parcel
+                    break if (not parcel.nil?) and parcel == R_HANDLED
+                }
       end
     end
+
+        def get_id
+            "rjab_#{Time.now.tv_sec}" # "rjab_seconds_since_epoch"
   end
   
-  def ask(node)
-    unless @ask_id = node.root.attributes['id']
-      debug("Ask: no ID - getting one")
-      @ask_id = get_id
-      node.root.attributes['id'] = @ask_id
+        def heartbeat; end
+
+        def last_error; end
+
+        def log(log_string)
+            if @log then puts "LOG: #{log_string}" end
     end
-    debug("Ask: id = #{@ask_id}")
 
-    str = ""
-    node.write str, -1
-    self.write str
+        def parse_data(source)                        
+            REXML::Document.parse_stream(source, self)
+        end
     
-    while (@answer == nil)
-      debug("Ask: waiting for answer")
-      process(1)
+        def raise_unless_connected
+            if not @connected
+                raise RuntimeError, "No connection/stream established!"
+            end
     end
 
-    answer = @answer
-    @answer = nil
-    debug("Ask: got answer") # FIXME: write out XML of answer
-    return answer
+        def read
+            rec_len = 1024
+            received = ''
+            while (data = @socket.recv(rec_len))
+                debug("recv (#{data.length}): #{data}\n")
+                received += data
+                break if data.length != 1024
   end
   
-  def register_handler(tag, &handler)
-    debug("Register_handler: tag type: #{tag}")
-    @handlers << [tag, handler]
+            # ewww... grotesque
+            if received =~ /<stream/ 
+                debug("Read: munging so REXML is happy")
+                received.chop!.concat('/>')
   end
 
-  def register_beat; end
+            parse_data(received)
+            return received
+        end
 
-  def start; end
+        def register_beat; end
 
-  def connected; end
+        def sha1(string)
+            return Digest::SHA1.new(string).hexdigest
+        end
 
-  def check_connected; end
+        def start; end
 
-  def get_id
-    "rjab_#{Time.now.tv_sec}" # "rjab_seconds_since_epoch"
+        def stream_header
+            # FIXME: find a way to move this crap into Jabber::NS and still allow for 
+            #  variable substitution
+            header = "<?xml version=\'1.0\'?><stream:stream to=\'#{@server}\' xmlns=\'jabber:client\' xmlns:stream=\'http://etherx.jabber.org/streams\'>"
   end
   
-  def heartbeat; end
+        def _write(data)
+            debug("Write: #{data}") 
+            @socket.write(data)
+        end
 
-end # Class: Connection
+    end # Class: Connection
 
 end # Module: Jabber
