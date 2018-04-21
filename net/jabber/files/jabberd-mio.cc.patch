--- jabberd/mio.cc.orig	2008-04-29 18:54:19.000000000 +0200
+++ jabberd/mio.cc	2008-04-29 19:00:45.000000000 +0200
@@ -673,11 +673,14 @@
 	sa.sin6_flowinfo = 0;
 
 	inet_pton(AF_INET6, addr_str, &sa.sin6_addr);
+	flag = 0;
+	setsockopt(newm->fd, IPPROTO_IPV6, IPV6_V6ONLY, (char*)&flag, sizeof(flag)); 
 #else
         struct sockaddr_in sa;
         sa.sin_family = AF_INET;
         sa.sin_port   = 0;
         inet_aton(xmlnode_get_data(xmlnode_get_list_item(xmlnode_get_tags(greymatter__, "io/bind", namespaces, temp_pool), 0)), &sa.sin_addr);
+	
 #endif
         bind(newm->fd, (struct sockaddr*)&sa, sizeof(sa));
     }
