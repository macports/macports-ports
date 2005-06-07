--- src/fileinfo.c.orig	2005-06-06 17:12:32.000000000 -0500
+++ src/fileinfo.c	2005-06-06 17:13:43.000000000 -0500
@@ -134,6 +134,14 @@
 void OutputFileInfo (char *path);
 static int UnixIsFolder (char *path);
 static OSErr GetForkSizes (const FSRef *fileRef,  UInt64 *totalLogicalForkSize, UInt64 *totalPhysicalForkSize, short fork);
+static short GetLabelNumber (short flags);
+static char* GetSizeString( UInt64 size, short sizeFormat);
+static OSStatus FSMakePath(FSRef fileRef, UInt8 *path, UInt32 maxPathSize);
+OSErr RetrieveStatData (FileInfoStruct *file);
+OSErr RetrieveFileInfo (FileInfoStruct *file);
+OSErr ProcessFinderInfo (FileInfoStruct *file);
+OSErr GetDateTimeStringFromUTCDateTime (UTCDateTime *utcDateTime, char *dateTimeString);
+char* GetFileNameFromPath (char *name);
 
 
 /*//////////////////////////////////////
