--- cryptusr.c.orig	2005-04-04 06:20:27.000000000 -0400
+++ cryptusr.c	2005-04-04 06:20:29.000000000 -0400
@@ -1523,7 +1523,7 @@
 	   cryptlib default user (actually we could and nothing bad would happen, 
 	   but we reserve the use of this name just in case) */
 	if( createInfo->strArgLen1 == defaultUserInfo.userNameLength && \
-		!strCompare( createInfo->strArg1, defaultUserInfo.userName, 
+		!strCompare( createInfo->strArg1, (char *)defaultUserInfo.userName, 
 					 defaultUserInfo.userNameLength ) )
 		return( CRYPT_ERROR_INITED );
 
