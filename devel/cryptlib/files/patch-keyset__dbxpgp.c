--- keyset/dbxpgp.c.orig	2005-04-04 05:43:12.000000000 -0400
+++ keyset/dbxpgp.c	2005-04-04 05:43:51.000000000 -0400
@@ -721,7 +721,7 @@
 		status = pgpReadPacketHeader( stream, &ctb, &packetLength );
 		if( cryptStatusError( status ) )
 			return( status );
-		pgpInfo->userID[ pgpInfo->lastUserID ] = sMemBufPtr( stream );
+		pgpInfo->userID[ pgpInfo->lastUserID ] = (char *)sMemBufPtr( stream );
 		pgpInfo->userIDlen[ pgpInfo->lastUserID++ ] = ( int ) packetLength;
 		status = sSkip( stream, packetLength );
 		}
