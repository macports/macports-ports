--- session/ssh.c.orig	2005-04-04 06:41:01.000000000 -0400
+++ session/ssh.c	2005-04-04 06:41:40.000000000 -0400
@@ -214,7 +214,7 @@
 
 static int readVersionString( SESSION_INFO *sessionInfoPtr )
 	{
-	const char *versionStringPtr = sessionInfoPtr->receiveBuffer + SSH_ID_SIZE;
+	const char *versionStringPtr = (char *)sessionInfoPtr->receiveBuffer + SSH_ID_SIZE;
 	int linesRead = 0, status;
 
 	/* Read the server version info, with the format for the ID string being
@@ -415,7 +415,7 @@
 int encodeString( BYTE *buffer, const BYTE *string, const int stringLength )
 	{
 	BYTE *bufPtr = buffer;
-	const int length = ( stringLength > 0 ) ? stringLength : strlen( string );
+	const int length = ( stringLength > 0 ) ? stringLength : strlen( (char *)string );
 
 	if( buffer != NULL )
 		{
