--- device/dev_sys.c.orig	2005-04-04 05:31:49.000000000 -0400
+++ device/dev_sys.c	2005-04-04 05:32:37.000000000 -0400
@@ -1142,12 +1142,13 @@
 *																			*
 ****************************************************************************/
 
+static void initCapabilities( void );
+
 /* Initialise and shut down the system device */
 
 static int initFunction( DEVICE_INFO *deviceInfo, const char *name,
 						 const int nameLength )
 	{
-	STATIC_FN void initCapabilities( void );
 	int status;
 
 	UNUSED( name );
