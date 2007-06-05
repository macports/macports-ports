--- src/rend-osx.c.org.c	2004-12-08 21:05:54.000000000 -0800
+++ src/rend-osx.c	2007-06-04 23:39:02.000000000 -0700
@@ -169,6 +169,7 @@
     case REND_MSG_TYPE_REGISTER:
 	DPRINTF(E_DBG,L_REND,"Registering %s.%s (%d)\n",msg.type,msg.name,msg.port);
 	usPort=msg.port;
+	usPort = htons(usPort);
 	dns_ref=DNSServiceRegistrationCreate(msg.name,msg.type,"",usPort,
 					     "Database ID=bedabb1edeadbea7",rend_reply,nil);
 	if(rend_addtorunloop(dns_ref)) {
