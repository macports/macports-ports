--- jabberd/lib/socket.cc.orig	2007-07-17 01:20:44.000000000 +0200
+++ jabberd/lib/socket.cc	2008-04-29 19:05:42.000000000 +0200
@@ -95,6 +95,8 @@
             sa.sin_addr.s_addr = saddr->s_addr;
 #endif
 
+		flag = 0;
+		setsockopt(s, IPPROTO_IPV6, IPV6_V6ONLY, (char*)&flag, sizeof(flag)); 
         if(bind(s,(struct sockaddr*)&sa,sizeof sa) < 0)
         {
             close(s);
