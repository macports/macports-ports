diff -ruP src/osdep/unix-orig/ckp_osx.c src/osdep/unix/ckp_osx.c
--- src/osdep/unix-orig/ckp_osx.c	Thu Jan  1 01:00:00 1970
+++ src/osdep/unix/ckp_osx.c	Wed Nov  5 00:18:14 2003
@@ -0,0 +1,471 @@
+/*
+ * Program:	OS X check password
+ *
+ * Author:	Mark Crispin
+ *		Networks and Distributed Computing
+ *		Computing & Communications
+ *		University of Washington
+ *		Administration Building, AG-44
+ *		Seattle, WA  98195
+ *		Internet: MRC@CAC.Washington.EDU
+ *
+ * Modified by: Tom Brown
+ *              tb000@maczipit.com
+ *              (Modifications provided as-is, with no warranties, including the warranty
+ *              of merchantability or fitness for a particular purpose.)
+ *
+ * Date:	1 August 1988
+ * Last Edited:	October 26, 2003
+ * 
+ * The IMAP toolkit provided in this Distribution is
+ * Copyright 2000 University of Washington.
+ * The full text of our legal notices is contained in the file called
+ * CPYRIGHT, included with this Distribution.
+ *
+ * This file contains code adapted from Apple's sample code. The following notice applies
+ * to the Apple-derived portion of this file.
+ *
+ 	Copyright:	© 2000-2001 by Apple Computer, Inc., all rights reserved.
+
+	IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in
+	consideration of your agreement to the following terms, and your use, installation, 
+	modification or redistribution of this Apple software constitutes acceptance of these 
+	terms.  If you do not agree with these terms, please do not use, install, modify or 
+	redistribute this Apple software.
+	
+	In consideration of your agreement to abide by the following terms, and subject to these 
+	terms, Apple grants you a personal, non-exclusive license, under Apple’s copyrights in 
+	this original Apple software (the "Apple Software"), to use, reproduce, modify and 
+	redistribute the Apple Software, with or without modifications, in source and/or binary 
+	forms; provided that if you redistribute the Apple Software in its entirety and without 
+	modifications, you must retain this notice and the following text and disclaimers in all 
+	such redistributions of the Apple Software.  Neither the name, trademarks, service marks 
+	or logos of Apple Computer, Inc. may be used to endorse or promote products derived from 
+	the Apple Software without specific prior written permission from Apple. Except as expressly
+	stated in this notice, no other rights or licenses, express or implied, are granted by Apple
+	herein, including but not limited to any patent rights that may be infringed by your 
+	derivative works or by other works in which the Apple Software may be incorporated.
+	
+	The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, 
+	EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, 
+	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS 
+	USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
+	
+	IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
+	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
+	OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
+	REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND 
+	WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR 
+	OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <CoreServices/CoreServices.h>
+#include <DirectoryService/DirServices.h>
+#include <DirectoryService/DirServicesUtils.h>
+#include <DirectoryService/DirServicesConst.h>
+
+  // Liberally borrowed from Apple's Open Directory SDK
+
+typedef enum {
+	// NULL allocation errors
+	kErrDataBufferAllocate			= 1,
+	kErrDataNodeAllocateBlock,
+	kErrDataNodeAllocateString,
+	kErrDataListAllocate,
+	kErrBuildFromPath,
+	kErrGetPathFromList,
+	kErrBuildListFromNodes,
+	kErrBuildListFromStrings,
+	kErrBuildListFromStringsAlloc,
+	kErrDataListCopyList,
+	kErrAllocAttributeValueEntry,
+
+	// Error associations
+	kErrOpenDirSrvc,
+	kErrCloseDirSrvc,
+	kErrDataListDeallocate,
+	kErrDataBufferDeAllocate,
+	kErrFindDirNodes,
+	kErrOpenRecord,
+	kErrCreateRecordAndOpen,
+	kErrCloseRecord,
+	kErrDeleteRecord,
+	kErrDataNodeDeAllocate,
+
+	kErrDataBuffDealloc,
+	kErrCreateRecord,
+	kErrAddAttribute,
+	kErrAddAttributeValue,
+	kErrSetAttributeValue,
+	kErrGetRecAttrValueByIndex,
+	kErrGetDirNodeName,
+	kErrOpenDirNode,
+	kErrCloseDirNode,
+	kErrGetRecordList,
+
+	kErrGetRecordEntry,
+	kErrGetAttributeEntry,
+	kErrGetAttributeValue,
+	kErrDeallocAttributeValueEntry,
+	kErrDoDirNodeAuth,
+	kErrGetRecordNameFromEntry,
+	kErrGetRecordTypeFromEntry,
+	kErrGetRecordAttributeInfo,
+	kErrGetRecordReferenceInfo,
+	kErrGetDirNodeInfo,
+
+	kErrGetDirNodeCount,
+	kErrGetDirNodeList,
+	kErrRemoveAttributeValue,
+	kErr,
+
+	kErrMemoryAlloc,
+	kErrEmptyDataBuff,
+	kErrEmptyDataParam,
+	kErrBuffTooSmall,
+	kErrMaxErrors,
+	kUnknownErr = 0xFF
+} eErrCodes;
+
+long SetUpAuthBuffs (   tDirReference dsRef, tDataBuffer **outAuthBuff,
+			unsigned long inAuthBuffSize,
+			tDataBuffer **outStepBuff,
+			unsigned long  inStepBuffSize,
+			tDataBuffer **outTypeBuff,
+                        const char *inAuthMethod )
+{
+	long		error	= eDSNoErr;
+	long		error2	= eDSNoErr;
+
+	if ( (outAuthBuff == nil) || (outStepBuff == nil) ||
+		 (outTypeBuff == nil) || (inAuthMethod == nil) )
+	{
+		return( kErrEmptyDataParam );
+	}
+
+	*outAuthBuff = dsDataBufferAllocate( dsRef, inAuthBuffSize );
+	if ( *outAuthBuff != nil )
+	{
+		*outStepBuff = dsDataBufferAllocate( dsRef, inStepBuffSize );
+		if ( *outStepBuff != nil )
+		{
+			*outTypeBuff = dsDataNodeAllocateString( dsRef, inAuthMethod );
+			if ( *outTypeBuff == nil )
+			{
+				error = kErrDataNodeAllocateString;
+			}
+		}
+		else
+		{
+			error = kErrDataBufferAllocate;
+		}
+	}
+	else
+	{
+		error = kErrDataBufferAllocate;
+	}
+
+	if ( error != eDSNoErr )
+	{
+		if ( *outAuthBuff != nil )
+		{
+			error2 = dsDataBufferDeAllocate( dsRef, *outAuthBuff );
+		}
+
+		if ( *outStepBuff != nil )
+		{
+			error2 = dsDataBufferDeAllocate( dsRef, *outStepBuff );
+		}
+
+		if ( *outTypeBuff != nil )
+		{
+			error2 = dsDataBufferDeAllocate( dsRef, *outTypeBuff );
+		}
+	}
+
+	return( error );
+
+} // SetUpAuthBuffs
+
+long FillAuthBuff ( tDataBuffer *inAuthBuff, unsigned long inCount, unsigned long inLen, void *inData, ... )
+{
+	long		error		= eDSNoErr;
+	unsigned long	curr		= 0;
+	unsigned long   buffSize	= 0;
+	unsigned long   count		= inCount;
+	unsigned long   len             = inLen;
+	void            *data		= inData;
+	bool		firstPass	= true;
+	char            *p              = nil;
+	va_list		args;
+
+	// If the buffer is nil, we have nowhere to put the data
+	if ( inAuthBuff == nil )
+	{
+		return( kErrEmptyDataBuff );
+	}
+
+	// If the buffer is nil, we have nowhere to put the data
+	if ( inAuthBuff->fBufferData == nil )
+	{
+		return( kErrEmptyDataBuff );
+	}
+
+	// Make sure we have data to copy
+	if ( (inLen != 0) && (inData == nil) )
+	{
+		return( kErrEmptyDataParam );
+	}
+
+	// Get buffer info
+	p = inAuthBuff->fBufferData;
+	buffSize = inAuthBuff->fBufferSize;
+
+	// Set up the arg list
+	va_start( args, inLen );
+
+	while ( count-- > 0 )
+	{
+		if ( !firstPass )
+		{
+			len = va_arg( args, unsigned long );
+			data = va_arg( args, void * );
+		}
+
+		if ( (curr + len) > buffSize )
+		{
+			// This is bad, lets bail
+			return( kErrBuffTooSmall );
+		}
+
+		memcpy( &(p[ curr ]), &len, sizeof( long ) );
+		curr += sizeof( long );
+
+		if ( len > 0 )
+		{
+			memcpy( &(p[ curr ]), data, len );
+			curr += len;
+		}
+		firstPass = false;
+	}
+
+	inAuthBuff->fBufferLength = curr;
+
+	return( error );
+
+} // FillAuthBuff
+
+
+long DoClearTextAuth ( tDirReference dsRef, tDirNodeReference inNode, char *inName, char *inPasswd )
+{
+    long    error= eDSNoErr;
+    long    error2= eDSNoErr;
+    tDataBuffer   *pAuthBuff= nil;
+    tDataBuffer   *pStepBuff= nil;
+    tDataNode   *pAuthType= nil;
+
+    error = SetUpAuthBuffs( dsRef, &pAuthBuff, 2048, &pStepBuff, 2048, &pAuthType, kDSStdAuthNodeNativeClearTextOK );
+    if ( error == eDSNoErr )
+    {
+        error = FillAuthBuff ( pAuthBuff, 2,
+				 (long)strlen( inName ), inName,
+				 (long)strlen( inPasswd ), inPasswd );
+
+        if ( error == eDSNoErr )
+        {
+            error = dsDoDirNodeAuth( inNode, pAuthType, true, pAuthBuff, pStepBuff, nil );
+        }
+            
+        error2 = dsDataBufferDeAllocate( dsRef, pAuthBuff );
+        error2 = dsDataBufferDeAllocate( dsRef, pStepBuff );
+        error2 = dsDataBufferDeAllocate( dsRef, pAuthType );
+    }
+
+    return( error );
+
+} // DoClearTextAuth
+
+static long OpenDirNode ( tDirReference dsRef, char *inNodeName, tDirNodeReference *outNodeRef )
+{
+	long        error		= eDSNoErr;
+	long        error2		= eDSNoErr;
+	tDataList   *pDataList	= nil;
+
+        pDataList = dsBuildFromPath( dsRef, inNodeName, "/" );
+        if ( pDataList != nil )
+        {
+                error = dsOpenDirNode( dsRef, pDataList, outNodeRef );
+                error2 = dsDataListDeallocate( dsRef, pDataList );
+        }
+        else
+        {
+                error = kErrBuildFromPath;
+        }
+
+	return( error );
+
+} // OpenDirNode
+
+static long FindDirectoryNodes (    tDirReference dsRef,
+                                    char *inNodeName,
+                                    tDirPatternMatch inMatch,
+                                    char **outNodeName)
+{
+	long			error			= eDSNoErr;
+	long			error2			= eDSNoErr;
+	bool			done			= false;
+	unsigned long			uiCount			= 0;
+	unsigned long			uiIndex			= 0;
+	tDataList	   *pNodeNameList	= nil;
+	tDataList	   *pDataList		= nil;
+	char		   *pNodeName		= nil;
+        tDataBuffer         *buf;
+
+		if ( inNodeName != nil )
+		{
+			pNodeNameList = dsBuildFromPath( dsRef, inNodeName, "/" );
+			if ( pNodeNameList == nil )
+			{
+				return( kErrDataNodeAllocateString );
+			}
+		}
+
+                buf = dsDataBufferAllocate( dsRef, 1024);
+		do {
+			error = dsFindDirNodes( dsRef, buf, pNodeNameList, inMatch, &uiCount, nil );
+			if ( error == eDSBufferTooSmall )
+			{
+				unsigned long buffSize = buf->fBufferSize;
+				dsDataBufferDeAllocate( dsRef, buf );
+				buf = nil;
+				buf = dsDataBufferAllocate( dsRef, buffSize * 2 );
+			}
+		} while ( error == eDSBufferTooSmall );
+		if ( error == eDSNoErr )
+		{
+
+			if ( uiCount != 0 )
+			{
+				pDataList = dsDataListAllocate( dsRef );
+				if ( pDataList != nil )
+				{
+					for ( uiIndex = 1; (uiIndex <= uiCount) && (error == eDSNoErr); uiIndex++ )
+					{
+						error = dsGetDirNodeName( dsRef, buf, uiIndex, &pDataList );
+						if ( error == eDSNoErr )
+						{
+							pNodeName = dsGetPathFromList( dsRef, pDataList, "/" );
+							if ( pNodeName != nil )
+							{
+
+								if ( (outNodeName != nil) && !done )
+								{
+									*outNodeName = pNodeName;
+									done = true;
+								}
+								else
+								{
+									free( pNodeName );
+									pNodeName = nil;
+								}
+
+								error2 = dsDataListDeallocate( dsRef, pDataList );
+							}
+							else
+							{
+								error = kErrGetPathFromList;
+							}
+						}
+					}
+				}
+				else
+				{
+					error = kErrDataListAllocate;
+				}
+			}
+		}
+
+		if ( pNodeNameList != nil )
+		{
+			error2 = dsDataListDeallocate( dsRef, pNodeNameList );
+		}
+
+        dsDataBufferDeAllocate( dsRef, buf );
+	return( error );
+
+} // FindDirectoryNodes
+
+static long MyOpenDirNode ( tDirReference dirRef,
+			    tDirNodeReference *outNodeRef )
+{
+    long    siStatus		= noErr;
+    char    *pNodeName		= nil;
+    
+    // siStatus = OpenDirectoryServices();
+    if ( siStatus != noErr )
+    {
+            return( siStatus );
+    }
+    
+    // Find and open local node
+    siStatus = FindDirectoryNodes( dirRef, nil, eDSLocalNodeNames, &pNodeName );
+    if ( siStatus == noErr )
+    {
+            siStatus = OpenDirNode( dirRef, pNodeName, outNodeRef );
+    
+            free( pNodeName );
+            pNodeName = nil;
+    }
+    
+    return siStatus;
+}
+
+/* Check password
+ * Accepts: login passwd struct
+ *	    password string
+ *	    argument count
+ *	    argument vector
+ * Returns: passwd struct if password validated, NIL otherwise
+ */
+
+struct passwd *checkpw (struct passwd *pw,char *pass,int argc,char *argv[])
+{
+    if (pw->pw_passwd && pw->pw_passwd[0] && pw->pw_passwd[1])
+    {
+        long dirStatus = eDSNoErr;
+        tDirNodeReference nodeRef = NULL;
+        tDirReference dirRef = NULL;
+        
+        dirStatus = dsOpenDirService( &dirRef );
+        if ( dirStatus == eDSNoErr )
+        {
+            dirStatus = MyOpenDirNode( dirRef, &nodeRef );
+        }
+        
+        if (dirStatus == eDSNoErr)
+        {
+            dirStatus = DoClearTextAuth(dirRef, nodeRef, pw->pw_name, pass);
+        }
+        
+        // Any error causes us to fail (including failure of authentication, above)
+        if (dirStatus != eDSNoErr)
+        {
+            pw = NULL;
+        }
+        
+        if (nodeRef)
+        {
+            dsCloseDirNode( nodeRef );
+        }
+        
+        if ( dirRef != NULL )
+        {
+            dirStatus = dsCloseDirService( dirRef );
+        }
+        
+        return pw;    
+    }
+    else
+    {
+        return NULL;
+    }
+}
