--- misc/net_http.c.orig	2005-04-04 06:21:03.000000000 -0400
+++ misc/net_http.c	2005-04-04 06:21:54.000000000 -0400
@@ -323,7 +323,7 @@
 	length = sPrintf( headerBuffer, "%s %s %s\r\n\r\n",
 					  isHTTP10( stream ) ? "HTTP/1.0" : "HTTP/1.1",
 					  statusString, errorString );
-	return( stream->bufferedTransportWriteFunction( stream, headerBuffer, length,
+	return( stream->bufferedTransportWriteFunction( stream, (unsigned char *)headerBuffer, length,
 													TRANSPORT_FLAG_FLUSH ) );
 	}
 
@@ -750,7 +750,7 @@
 	headerLength = stell( &headerStream );
 	assert( sStatusOK( &headerStream ) );
 	sMemDisconnect( &headerStream );
-	return( stream->bufferedTransportWriteFunction( stream, headerBuffer,
+	return( stream->bufferedTransportWriteFunction( stream, (unsigned char *)headerBuffer,
 													headerLength,
 													transportFlag ) );
 	}
@@ -865,7 +865,7 @@
 	if( isHTTP10( stream ) )
 		strcat( headerBuffer + headerPos, "Pragma: no-cache\r\n" );
 	strcat( headerBuffer + headerPos, "\r\n" );
-	return( stream->bufferedTransportWriteFunction( stream, headerBuffer,
+	return( stream->bufferedTransportWriteFunction( stream, (unsigned char *)headerBuffer,
 													strlen( headerBuffer ),
 													TRANSPORT_FLAG_NONE ) );
 	}
