--- keyset/dbxdca.c.orig	2003-12-12 02:46:32.000000000 -0500
+++ keyset/dbxdca.c	2005-04-04 06:33:18.000000000 -0400
@@ -62,7 +62,7 @@
 			"SELECT certID FROM certLog WHERE subjCertID = '$' "
 				"AND action = " TEXT_CERTACTION_REQUEST_RENEWAL,
 					   certID );
-		status = dbmsQuery( sqlBuffer, certData, &certDataLength, 0,
+		status = dbmsQuery( sqlBuffer, (unsigned char *)certData, &certDataLength, 0,
 							DBMS_QUERY_NORMAL );
 		if( cryptStatusError( status ) )
 			return( status );
@@ -74,7 +74,7 @@
 			"SELECT certID FROM certLog WHERE reqCertID = '$' "
 				"AND action = " TEXT_CERTACTION_CERT_CREATION,
 					   certID );
-		status = dbmsQuery( sqlBuffer, certData, &certDataLength, 0,
+		status = dbmsQuery( sqlBuffer, (unsigned char *)certData, &certDataLength, 0,
 							DBMS_QUERY_NORMAL );
 		if( cryptStatusError( status ) )
 			return( status );
@@ -349,7 +349,7 @@
 	writeSequence( &stream, sizeofShortInteger( -errorStatus ) + \
 							( int ) sizeofObject( errorStringLength ) );
 	writeShortInteger( &stream, -errorStatus, DEFAULT_TAG );
-	writeCharacterString( &stream, errorString, errorStringLength,
+	writeCharacterString( &stream, (unsigned char *)errorString, errorStringLength,
 						  BER_STRING_UTF8 );
 	errorDataLength = stell( &stream );
 	sMemDisconnect( &stream );
@@ -440,6 +440,11 @@
 						 KEYMGMT_ITEM_PUBLICKEY, KEYMGMT_FLAG_NONE ) );
 	}
 
+static int caRevokeCert( DBMS_INFO *dbmsInfo,
+						 const CRYPT_CERTIFICATE iCertRequest,
+						 const CRYPT_CERTIFICATE iCertificate,
+						 const CRYPT_CERTACTION_TYPE action );
+
 /* Handle an indirect cert revocation (one where we need to reverse a cert
    issue or otherwise remove the cert without obtaining a direct revocation
    request from the user).  The various revocation situations are:
@@ -467,10 +472,6 @@
 							 const CRYPT_CERTIFICATE iCertificate,
 							 const CRYPT_CERTACTION_TYPE action )
 	{
-	STATIC_FN int caRevokeCert( DBMS_INFO *dbmsInfo,
-								const CRYPT_CERTIFICATE iCertRequest,
-								const CRYPT_CERTIFICATE iCertificate,
-								const CRYPT_CERTACTION_TYPE action );
 	MESSAGE_CREATEOBJECT_INFO createInfo;
 	time_t certDate;
 	int status;
@@ -1012,8 +1013,8 @@
 		   get the request that resulted in its creation */
 		dbmsFormatSQL( sqlBuffer,
 			"SELECT reqCertID FROM certLog WHERE certID = '$'",
-					   certID );
-		status = dbmsQuery( sqlBuffer, requestTypeData, &requestTypeLength,
+					   (unsigned char *)certID );
+		status = dbmsQuery( sqlBuffer, (char *)requestTypeData, &requestTypeLength,
 							0, DBMS_QUERY_NORMAL );
 		if( cryptStatusOK( status ) )
 			memcpy( certID, requestTypeData,
@@ -1031,8 +1032,8 @@
 	   type */
 	dbmsFormatSQL( sqlBuffer,
 		"SELECT action FROM certLog WHERE certID = '$'",
-				   certID );
-	status = dbmsQuery( sqlBuffer, requestTypeData, &requestTypeLength, 0,
+				   (unsigned char *)certID );
+	status = dbmsQuery( sqlBuffer, (char *)requestTypeData, &requestTypeLength, 0,
 						DBMS_QUERY_NORMAL );
 	if( cryptStatusOK( status ) )
 		switch( requestTypeData[ 0 ] )
