--- popper/pop_pass.c.orig	2006-03-10 07:32:38.000000000 +0900
+++ popper/pop_pass.c	2006-09-17 17:46:00.000000000 +0900
@@ -40,6 +40,10 @@
  *                <security/pam_appl.h> (otherwise build fails)
  *                (thanks to Kyle McKay for the patch)
  *
+ *     11/13/03  [pguyot]
+ *             - Added DirectoryService authentication for MacOS X (required on
+ *               10.3+).
+ *
  *     01/16/03  [rcg]
  *             - Renamed PASSWD macro to QPASSWD to avoid redefining
  *               PASSWD in shadow.h.
@@ -1054,6 +1058,143 @@
 #    endif /* AIX */
 
 
+/*----------------------------------------------- DARWIN/MacOS X  */
+#    ifdef DARWIN
+
+#      define DECLARED_AUTH_USER
+
+/*
+ * MacOS X specific authentication using OpenDirectory (previously known
+ * as DirectoryService).
+ *
+ * This should work with MacOS X 10.2 and higher (i.e. Darwin 6 and higher).
+ * It's the only method, except PAM, on MacOS X 10.3 aka Panther (Darwin 7).
+ * I don't know if this actually works on Darwin/x86.
+ */
+
+#include <DirectoryService/DirServices.h>
+#include <DirectoryService/DirServicesConst.h>
+#include <DirectoryService/DirServicesTypes.h>
+#include <DirectoryService/DirServicesUtils.h>
+
+static int
+auth_user ( POP *p, struct passwd *pw )
+{
+    int     		rslt      	= POP_FAILURE;
+    tDirReference	theDirRef	= NULL;
+    tDirStatus		theDirErr	= eDSNoErr;
+
+	/*
+	 * Create a reference to the OpenDirectory service.
+	 */
+	theDirErr = dsOpenDirService( &theDirRef );
+	if (theDirErr == eDSNoErr)
+	{
+		/*
+		 * Build the path to the node.
+		 */
+		tDataListPtr theNodePath = dsBuildFromPath( theDirRef, "/NetInfo/root/", "/" );
+		
+		if (theNodePath != NULL)
+		{
+			/*
+			 * Open the node.
+			 */
+			tDirNodeReference theNodeRef = NULL;
+			theDirErr = dsOpenDirNode( theDirRef, theNodePath, &theNodeRef );
+			if (theDirErr == eDSNoErr)
+			{
+				/*
+				 * Do the actual authentication work.
+				 */
+				tDataNodePtr theAuthTypeToUse = NULL;
+				tDataBufferPtr theAuthDataBuffer = NULL;
+				tDataBufferPtr theAuthRespBuffer = NULL;
+				long theNameLength = strlen( p->user );
+				long thePassLength = strlen( p->pop_parm[1] );
+				long theBufferCursor = 0;
+				tContextData theContinueData = NULL;
+				
+				/* We allow clear text passwords */
+				theAuthTypeToUse =
+					dsDataNodeAllocateString( theDirRef, kDSStdAuthNodeNativeClearTextOK );
+				
+			    theAuthDataBuffer = dsDataBufferAllocate(
+			    						theDirRef,
+			    						sizeof(long) + theNameLength
+			    						+ sizeof(long) + thePassLength );
+				theAuthRespBuffer = dsDataBufferAllocate( theDirRef, 512 );
+
+				/* Store data in the buffer */
+				/* the length, the name, the length, the password */
+				memcpy( &theAuthDataBuffer->fBufferData[theBufferCursor],
+					&theNameLength, sizeof( theNameLength ) );
+				theBufferCursor += sizeof( theNameLength );
+				memcpy( &theAuthDataBuffer->fBufferData[theBufferCursor],
+					p->user, theNameLength );
+				theBufferCursor += theNameLength;
+				memcpy( &theAuthDataBuffer->fBufferData[theBufferCursor],
+					&thePassLength, sizeof( thePassLength ) );
+				theBufferCursor += sizeof( thePassLength );
+				memcpy( &theAuthDataBuffer->fBufferData[theBufferCursor],
+					p->pop_parm[1], thePassLength );
+				theAuthDataBuffer->fBufferLength = theBufferCursor + thePassLength;
+
+				if (dsDoDirNodeAuth(
+						theNodeRef,
+						theAuthTypeToUse,
+						1 /* true */,
+						theAuthDataBuffer,
+						theAuthRespBuffer,
+						&theContinueData ) == eDSNoErr)
+				{
+					rslt = POP_SUCCESS;
+				} else {
+					pop_log ( p, POP_NOTICE, HERE, "Authentication failed for user %s", p->user );
+				}
+				
+				/* clean up */
+				(void) dsDataBufferDeAllocate( theDirRef, theAuthDataBuffer );
+				(void) dsDataBufferDeAllocate( theDirRef, theAuthRespBuffer );
+				(void) dsDataNodeDeAllocate( theDirRef, theAuthTypeToUse );
+			}
+			
+			if (theNodeRef != NULL)
+			{
+				(void) dsCloseDirNode( theNodeRef );
+			}
+			
+			dsDataListDeallocate( theDirRef, theNodePath );
+			free( theNodePath );
+		}
+	}
+	
+	/*
+	 * Clean up.
+	 */
+	if (theDirRef != NULL)
+	{
+		(void) dsCloseDirService( theDirRef );
+	}
+
+	if (rslt != POP_SUCCESS)
+	{
+		if (theDirErr != eDSNoErr)
+		{
+			pop_log( p, POP_NOTICE, HERE,
+					"An error occurred with OpenDirectory authentication for user %s (%i)",
+					p->user, theDirErr );
+		}
+		
+		sleep  ( SLEEP_SECONDS );
+		pop_msg ( p, POP_FAILURE, HERE, ERRMSG_PW, p->user );
+	}
+
+    return rslt;
+}
+
+#    endif /* DARWIN/MacOS X */
+
 /*----------------------------------------------- generic AUTH_USER */
 #    ifndef DECLARED_AUTH_USER 
 
