--- Frameworks/AIUtilities Framework/NDResourceFork.m.orig	2005-02-18 02:33:22.000000000 -0500
+++ Frameworks/AIUtilities Framework/NDResourceFork.m	2005-04-03 19:58:58.000000000 -0400
@@ -12,14 +12,84 @@
 #import "NDResourceFork.h"
 #import "NSString+NDCarbonUtilities.h"
 
+NSData * dataFromResourceHandle( Handle aResourceHandle );
+BOOL operateOnResourceUsingFunction( short int afileRef, ResType aType, NSString * aName, short int anId, BOOL (*aFunction)(Handle,ResType,NSString*,short int,void*), void * aContext );
+
+	static BOOL getDataFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext )
+	{
+		NSData	** theData = (NSData**)aContext;
+		*theData = dataFromResourceHandle( aResHandle );
+		return *theData != nil;
+	}
+
+	static BOOL removeResourceFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext )
+	{
+		if( aResHandle )
+			RemoveResource( aResHandle );		// Disposed of in current resource file
+		return !aResHandle || noErr == ResError( );
+	}
+
+	static BOOL getNameFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext )
+	{
+		Str255		thePName;
+		NSString		** theString = (NSString **)aContext;
+	
+		if( aResHandle )
+		{
+			GetResInfo( aResHandle, &anId, &aType, thePName );
+			if( noErr ==  ResError( ) )
+				*theString = [NSString stringWithPascalString:thePName];
+		}
+	
+		return *theString != nil;
+	}
+
+	static BOOL getIdFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext  )
+	{
+		Str255		thePName;
+	
+		if( aResHandle && [aName getPascalString:(StringPtr)thePName length:sizeof(thePName)] )
+		{
+			GetResInfo( aResHandle, &anId, &aType, thePName );
+			return noErr ==  ResError( );
+		}
+		else
+			return NO;
+	}
+
+	static BOOL getAttributesFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext )
+	{
+		short int		* theAttributes = (short int*)aContext;
+		if( aResHandle )
+		{
+			*theAttributes = GetResAttrs( aResHandle );
+			return noErr ==  ResError( );
+		}
+	
+		return NO;
+	}
+
+	static BOOL setAttributesFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext  )
+	{
+		short int		theAttributes = *(short int*)aContext;
+		if( aResHandle )
+		{
+			theAttributes &= ~(resPurgeable|resChanged); // these attributes should not be changed
+			SetResAttrs( aResHandle, theAttributes);
+			if( noErr ==  ResError( ) )
+			{
+				ChangedResource(aResHandle);
+				return noErr ==  ResError( );
+			}
+		}
+		return NO;
+	}
+
 /*
  * class implementation NDResourceFork
  */
 @implementation NDResourceFork
 
-NSData * dataFromResourceHandle( Handle aResourceHandle );
-BOOL operateOnResourceUsingFunction( short int afileRef, ResType aType, NSString * aName, short int anId, BOOL (*aFunction)(Handle,ResType,NSString*,short int,void*), void * aContext );
-
 /*
  * resourceForkForReadingAtURL:
  */
@@ -222,7 +292,6 @@
  */
 - (NSData *)dataForType:(ResType)aType Id:(short int)anId
 {
-	static BOOL getDataFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext );
 	NSData	* theData = nil;
 	
 	if( operateOnResourceUsingFunction( fileReference, aType, nil, anId, getDataFunction, (void*)&theData )  )
@@ -236,7 +305,6 @@
  */
 - (NSData *)dataForType:(ResType)aType named:(NSString *)aName
 {
-	static BOOL getDataFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext);
 	NSData	* theData = nil;
 
 	if( operateOnResourceUsingFunction( fileReference, aType, aName, 0, getDataFunction, (void*)&theData )  )
@@ -244,13 +312,6 @@
 	else
 		return nil;
 }
-	static BOOL getDataFunction( Handle aResHandle, ResType aType, short int anId, NSString * aName, void * aContext )
-	{
-		NSData	** theData = (NSData**)aContext;
-		*theData = dataFromResourceHandle( aResHandle );
-		return *theData != nil;
-	}
-
 
 /*
  * -everyResourceType
@@ -293,23 +354,14 @@
  */
 - (BOOL)removeType:(ResType)aType Id:(short int)anId
 {
-	static BOOL removeResourceFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext );
-	
 	return operateOnResourceUsingFunction( fileReference, aType, nil, anId, removeResourceFunction,  NULL);
 }
-	static BOOL removeResourceFunction( Handle aResHandle, ResType aType, short int anId, NSString * aName, void * aContext )
-	{
-		if( aResHandle )
-			RemoveResource( aResHandle );		// Disposed of in current resource file
-		return !aResHandle || noErr == ResError( );
-	}
 
 /*
  * nameOfResourceType:Id:
  */
 - (NSString *)nameOfResourceType:(ResType)aType Id:(short int)anId
 {
-	static BOOL getNameFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext );
 	NSString		* theString = nil;
 
 	if( operateOnResourceUsingFunction( fileReference, aType, nil, anId, getNameFunction, (void*)&theString ) )
@@ -318,90 +370,34 @@
 		return nil;
 
 }
-	static BOOL getNameFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext )
-	{
-		Str255		thePName;
-		NSString		** theString = (NSString **)aContext;
-	
-		if( aResHandle )
-		{
-			GetResInfo( aResHandle, &anId, &aType, thePName );
-			if( noErr ==  ResError( ) )
-				*theString = [NSString stringWithPascalString:thePName];
-		}
-	
-		return *theString != nil;
-	}
 
 /*
  * getId:OfResourceType:Id:
  */
 - (BOOL)getId:(short int *)anId ofResourceType:(ResType)aType named:(NSString *)aName
 {
-	static BOOL getIdFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext );
 	return operateOnResourceUsingFunction( fileReference, aType, aName, 0, getIdFunction, NULL );
 }
-	static BOOL getIdFunction( Handle aResHandle, ResType aType, short int anId, NSString * aName, void * aContext  )
-	{
-		Str255		thePName;
-	
-		if( aResHandle && [aName getPascalString:(StringPtr)thePName length:sizeof(thePName)] )
-		{
-			GetResInfo( aResHandle, &anId, &aType, thePName );
-			return noErr ==  ResError( );
-		}
-		else
-			return NO;
-	}
 
 /*
  * -attributeFlags:forResourceType:Id:
  */
 - (BOOL)getAttributeFlags:(short int*)attributes forResourceType:(ResType)aType Id:(short int)anId
 {
-	static BOOL getAttributesFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext );
 	return operateOnResourceUsingFunction( fileReference, aType, nil, anId, getAttributesFunction, (void*)attributes );
 }
-	static BOOL getAttributesFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext )
-	{
-		short int		* theAttributes = (short int*)aContext;
-		if( aResHandle )
-		{
-			*theAttributes = GetResAttrs( aResHandle );
-			return noErr ==  ResError( );
-		}
-	
-		return NO;
-	}
 
 /*
  * -setAttributeFlags:forResourceType:Id:
  */
 - (BOOL)setAttributeFlags:(short int)attributes forResourceType:(ResType)aType Id:(short int)anId
 {
-	static BOOL		setAttributesFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext );
 	BOOL				theSuccess;
 
 	NSLog(@"WARRING: Currently the setAttributeFlags:forResourceType:Id: does not work");
 	theSuccess = operateOnResourceUsingFunction( fileReference, aType, nil, anId, setAttributesFunction, &attributes );
 	return theSuccess;
 }
-	static BOOL setAttributesFunction( Handle aResHandle, ResType aType, NSString * aName, short int anId, void * aContext  )
-	{
-		short int		theAttributes = *(short int*)aContext;
-		if( aResHandle )
-		{
-			theAttributes &= ~(resPurgeable|resChanged); // these attributes should not be changed
-			SetResAttrs( aResHandle, theAttributes);
-			if( noErr ==  ResError( ) )
-			{
-				ChangedResource(aResHandle);
-				return noErr ==  ResError( );
-			}
-		}
-		return NO;
-	}
-
 
 /*
  * -dataForEntireResourceFork
