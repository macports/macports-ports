--- session/scep.c.orig	2005-04-04 06:38:55.000000000 -0400
+++ session/scep.c	2005-04-04 06:40:00.000000000 -0400
@@ -135,7 +135,7 @@
 	if( sessionInfoPtr->flags & SESSION_ISENCODEDUSERID )
 		{
 		keyIDsize = decodePKIUserValue( keyIDbuffer, 
-						protocolInfo->transID, protocolInfo->transIDsize );
+						(char *)protocolInfo->transID, protocolInfo->transIDsize );
 		keyIDptr = keyIDbuffer;
 		}
 
@@ -214,7 +214,7 @@
 	if( cryptStatusError( status ) )
 		return( status );
 	buffer[ msgData.length ] = '\0';
-	status = aToI( buffer );
+	status = aToI( (char *)buffer );
 	if( status == 0 && *buffer != '0' )
 		/* atoi() can't really indicate an error except by returning 0, 
 		   which is identical to an SCEP success status.  In order to
@@ -755,7 +755,7 @@
 			protocolInfo->transIDsize );
 	sessionInfoPtr->userNameLength = protocolInfo->transIDsize;
 	if( protocolInfo->transIDsize == 17 && \
-		isPKIUserValue( protocolInfo->transID, protocolInfo->transIDsize ) )
+		isPKIUserValue( (char *)protocolInfo->transID, protocolInfo->transIDsize ) )
 		sessionInfoPtr->flags |= SESSION_ISENCODEDUSERID;
 
 	/* Check that we've been sent the correct type of message */
