--- src/core/archive.cpp.orig	2005-09-16 13:12:36.000000000 +1000
+++ src/core/archive.cpp	2013-03-08 07:28:07.000000000 +1100
@@ -886,8 +886,8 @@ void cLockedTemporaryFileArchive::OpenRe
         catch( eFSServices& e)
           {
             TSTRING errStr = TSS_GetString( cCore, core::STR_BAD_TEMPDIRECTORY );
-            eArchiveOpen e(strTempFile, errStr);
-            throw e;
+            eArchiveOpen e2(strTempFile, errStr);
+            throw e2;
           }
       }
     ///////////////////////////////////////////////////////////////////////////////
