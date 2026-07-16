--- lib/modules/Protocols.pmod/HTTP.pmod/Server.pmod/Request.pike.orig	2008-03-22 20:51:20.000000000 +0100
+++ lib/modules/Protocols.pmod/HTTP.pmod/Server.pmod/Request.pike	2008-03-22 20:51:32.000000000 +0100
@@ -368,7 +368,11 @@
     buf = buf[l..];
     return 1;
   }
-
+  else if (request_type == "PUT" )
+  {
+    body_raw = buf;
+    return 1; // do not read body when method is PUT
+  }
   my_fd->set_read_callback(read_cb_post);
   return 0; // delay
 }
