--- lib/http-access2.rb	Tue Feb 10 20:03:36 2004
+++ ../http-access-2_0_4-patched/lib/http-access2.rb	Tue Dec 14 18:44:17 2004
@@ -1250,8 +1250,8 @@
       retry_number = 0
       timeout(@connect_timeout) do
 	@socket = create_socket(site)
-	@src.host = @socket.addr[3]
-	@src.port = @socket.addr[1]
+    @src.host = IPSocket.getaddress( site.host )
+    @src.port = site.port
 	if @dest.scheme == 'https'
 	  @socket = create_ssl_socket(@socket)
 	  connect_ssl_proxy(@socket) if @proxy
