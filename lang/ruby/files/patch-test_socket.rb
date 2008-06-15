--- test/socket/test_socket.rb.orig	2008-06-05 23:17:00.000000000 -0700
+++ test/socket/test_socket.rb	2008-06-05 23:17:25.000000000 -0700
@@ -57,6 +57,14 @@
       }
     end
   end
+  
+  def test_getaddrinfo_raises_no_errors_on_port_argument_of_0
+    # Added 2008-06-05 to ensure that Mac OS X 10.5.3's changes to getaddrinfo don't cause
+    # Ruby's Socket-based classes to fail.
+    # Here are two of the situations I found that were causing erroneous errors
+    assert_nothing_raised(){Socket.getaddrinfo(Socket.gethostname, 0, Socket::AF_INET, Socket::SOCK_STREAM, nil, Socket::AI_CANONNAME)}
+    assert_nothing_raised(){TCPServer.open('localhost', 0)}
+  end
 
   def test_listen
     s = nil
