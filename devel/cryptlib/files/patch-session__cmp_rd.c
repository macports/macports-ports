--- session/cmp_rd.c.orig	2005-04-04 06:37:07.000000000 -0400
+++ session/cmp_rd.c	2005-04-04 06:38:08.000000000 -0400
@@ -5,6 +5,7 @@
 *																			*
 ****************************************************************************/
 
+#include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #if defined( INC_ALL )
@@ -421,7 +422,7 @@
 	   not much we can do with them in any case, so we skip them */
 	readSequence( stream, &endPos );
 	endPos += stell( stream );
-	status = readCharacterString( stream, string, &stringLength, maxLength,
+	status = readCharacterString( stream, (unsigned char *)string, &stringLength, maxLength,
 								  BER_STRING_UTF8 );
 	if( cryptStatusError( status ) )
 		{
@@ -1282,7 +1283,7 @@
 			}
 		else
 			{
-			decodedValuePtr = sessionInfoPtr->password;
+			decodedValuePtr = (unsigned char *)sessionInfoPtr->password;
 			decodedValueLength = sessionInfoPtr->passwordLength;
 			}
 
