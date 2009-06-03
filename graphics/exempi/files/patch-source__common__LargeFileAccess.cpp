--- bogus/source/common/LargeFileAccess.cpp.orig	2009-06-03 00:52:35.000000000 -0700
+++ bogus/source/common/LargeFileAccess.cpp	2009-06-03 00:53:01.000000000 -0700
@@ -37,7 +37,7 @@
 		FSRef fileRef;
 		SInt8 perm = ( (mode == 'r') ? fsRdPerm : fsRdWrPerm );
 		HFSUniStr255 dataForkName;
-		SInt16 refNum;
+		FSIORefNum refNum;
 		
 		OSErr err = FSGetDataForkName ( &dataForkName );
 		if ( err != noErr ) LFA_Throw ( "LFA_Open: FSGetDataForkName failure", kLFAErr_ExternalFailure );
@@ -98,7 +98,7 @@
 		FSRef fileRef;
 		SInt8 perm = ( (mode == 'r') ? fsRdPerm : fsRdWrPerm );
 		HFSUniStr255 rsrcForkName;
-		SInt16 refNum;
+		FSIORefNum refNum;
 		
 		OSErr err = FSGetResourceForkName ( &rsrcForkName );
 		if ( err != noErr ) LFA_Throw ( "LFA_OpenRsrc: FSGetResourceForkName failure", kLFAErr_ExternalFailure );
