--- keyset/dbxdbms.c.orig	2005-04-04 05:34:42.000000000 -0400
+++ keyset/dbxdbms.c	2005-04-04 05:37:07.000000000 -0400
@@ -69,7 +69,7 @@
 		/* Connect to the plugin */
 		initNetConnectInfo( &connectInfo, DEFAULTUSER_OBJECT_HANDLE, 
 							CRYPT_ERROR, CRYPT_ERROR, NET_OPTION_HOSTNAME );
-		connectInfo.name = bufPtr;
+		connectInfo.name = (char *)bufPtr;
 		status = sNetConnect( &dbmsInfo->stream, STREAM_PROTOCOL_TCPIP,
 							  &connectInfo, dbmsInfo->errorMessage, 
 							  &dbmsInfo->errorCode );
