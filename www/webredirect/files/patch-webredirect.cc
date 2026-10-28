--- webredirect.cc.old	Fri Jan 16 19:19:11 2004
+++ webredirect.cc	Fri Jan 16 19:19:41 2004
@@ -16,6 +16,8 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
+#undef isset
+
 using std::string;
 using std::endl;
 using std::clog;
@@ -61,7 +63,7 @@
 
 int checked_accept(int serv_sock) {
   struct sockaddr_in remote;
-  size_t len = sizeof(remote);
+  socklen_t len = sizeof(remote);
   
   int remote_fd = accept(serv_sock, reinterpret_cast<sockaddr*>(&remote),
 			 &len);
