--- keyset/dbxp15w.c.orig	2005-04-04 05:45:23.000000000 -0400
+++ keyset/dbxp15w.c	2005-04-04 05:46:28.000000000 -0400
@@ -502,7 +502,7 @@
 	sMemOpen( &stream, certAttributes, KEYATTR_BUFFER_SIZE );
 	writeSequence( &stream, commonAttributeSize );
 	if( commonAttributeSize )
-		writeCharacterString( &stream, pkcs15info->label,
+		writeCharacterString( &stream, (unsigned char *)pkcs15info->label,
 							  pkcs15info->labelLength, BER_STRING_UTF8 );
 	writeSequence( &stream, commonCertAttributeSize );
 	writeOctetString( &stream, pkcs15info->iD, pkcs15info->iDlength,
