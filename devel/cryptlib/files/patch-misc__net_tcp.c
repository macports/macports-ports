--- misc/net_tcp.c.orig	2005-04-04 06:22:37.000000000 -0400
+++ misc/net_tcp.c	2005-04-04 06:26:50.000000000 -0400
@@ -1111,10 +1111,10 @@
 	}
 #else
 
+static int initSocketPool( void );
+
 int netInitTCP( void )
 	{
-	STATIC_FN int initSocketPool( void );
-
 #ifdef __SCO_VERSION__
 	struct sigaction act, oact;
 
@@ -1155,10 +1155,10 @@
 	return( initSocketPool() );
 	}
 
+static void endSocketPool( void );
+
 void netEndTCP( void )
 	{
-	STATIC_FN void endSocketPool( void );
-
 	/* Clean up the socket pool state information */
 	endSocketPool();
 
@@ -1795,11 +1795,11 @@
 								CRYPT_ERROR_NOTFOUND, FALSE ) );
 
 	/* Skip the queries */
-	namePtr = dnsQueryInfo.buffer + NS_HFIXEDSZ;
-	endPtr = dnsQueryInfo.buffer + resultLen;
+	namePtr = (char *)dnsQueryInfo.buffer + NS_HFIXEDSZ;
+	endPtr = (char *)dnsQueryInfo.buffer + resultLen;
 	for( i = 0; i < qCount; i++ )
 		{
-		nameLen = dn_skipname( namePtr, endPtr );
+		nameLen = dn_skipname( (unsigned char *)namePtr, (unsigned char *)endPtr );
 		if( nameLen <= 0 )
 	        return( setSocketError( stream, "RR contains invalid question",
 		                            CRYPT_ERROR_BADDATA, FALSE ) );
@@ -1814,7 +1814,7 @@
 		{
 		int priority, port;
 
-		nameLen = dn_skipname( namePtr, endPtr );
+		nameLen = dn_skipname( (unsigned char *)namePtr, (unsigned char *)endPtr );
 		if( nameLen <= 0 )
 	        return( setSocketError( stream, "RR contains invalid answer",
 	                                CRYPT_ERROR_BADDATA, FALSE ) );
@@ -1825,14 +1825,14 @@
 		if( priority < minPriority )
 			{
 			/* We've got a new higher-priority host, use that */
-			nameLen = dn_expand( dnsQueryInfo.buffer, endPtr,
-								 namePtr, hostName, MAX_URL_SIZE - 1 );
+			nameLen = dn_expand( dnsQueryInfo.buffer, (unsigned char *)endPtr,
+								 (unsigned char *)namePtr, hostName, MAX_URL_SIZE - 1 );
 			*hostPort = port;
 			minPriority = priority;
 			}
 		else
 			/* It's a lower-priority host, skip it */
-			nameLen = dn_skipname( namePtr, endPtr );
+			nameLen = dn_skipname( (unsigned char *)namePtr, (unsigned char *)endPtr );
 		if( nameLen <= 0 )
 	        return( setSocketError( stream, "RR contains invalid answer",
 	                                CRYPT_ERROR_NOTFOUND, FALSE ) );
@@ -2278,7 +2278,7 @@
 	struct timeval tv;
 	fd_set readfds, writefds;
 	static const int trueValue = 1;
-	SIZE_TYPE intLength = sizeof( int );
+	socklen_t intLength = sizeof( int );
 	int value, status;
 
 	/* Wait around until the connect completes.  Some select()'s limit the
@@ -2370,7 +2370,7 @@
 	struct addrinfo *addrInfoPtr, *addrInfoCursor;
 	char portBuf[ 32 ];
 	static const int trueValue = 1;
-	SIZE_TYPE clientAddrLen = sizeof( SOCKADDR_STORAGE );
+	socklen_t clientAddrLen = sizeof( SOCKADDR_STORAGE );
 	int socketStatus, status;
 
 	/* Clear return value */
