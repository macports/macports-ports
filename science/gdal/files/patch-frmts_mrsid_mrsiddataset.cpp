--- frmts/mrsid/mrsiddataset.cpp.orig	2008-08-14 23:59:18.000000000 -0700
+++ frmts/mrsid/mrsiddataset.cpp	2008-08-15 00:05:20.000000000 -0700
@@ -1,5 +1,5 @@
 /******************************************************************************
- * $Id: mrsiddataset.cpp 12686 2007-11-09 19:31:29Z warmerdam $
+ * $Id$
  *
  * Project:  Multi-resolution Seamless Image Database (MrSID)
  * Purpose:  Read/write LizardTech's MrSID file format - Version 4+ SDK.
@@ -37,7 +37,7 @@
 #include <geo_normalize.h>
 #include <geovalues.h>
 
-CPL_CVSID("$Id: mrsiddataset.cpp 12686 2007-11-09 19:31:29Z warmerdam $");
+CPL_CVSID("$Id$");
 
 CPL_C_START
 double GTIFAngleToDD( double dfAngle, int nUOMAngle );
@@ -161,7 +161,11 @@
 {
     friend class MrSIDRasterBand;
 
+#if defined(LTI_SDK_MAJOR) && LTI_SDK_MAJOR >= 7
+    MrSIDImageReader    *poImageReader;
+#else
     LTIImageReader      *poImageReader;
+#endif
 
 #ifdef MRSID_ESDK
     LTIGeoFileImageWriter *poImageWriter;
@@ -690,7 +694,14 @@
     if ( poLTINav )
         delete poLTINav;
     if ( poImageReader && !bIsOverview )
+#if defined(LTI_SDK_MAJOR) && LTI_SDK_MAJOR >= 7
+    {
+        poImageReader->release();
+        poImageReader = NULL;
+    }
+#else
         delete poImageReader;
+#endif
 
     if ( pszProjection )
         CPLFree( pszProjection );
@@ -1250,6 +1261,7 @@
 /* -------------------------------------------------------------------- */
     MrSIDDataset        *poDS;
     const LTFileSpec    oFileSpec( poOpenInfo->pszFilename );
+    LT_STATUS           eStat;
 
     poDS = new MrSIDDataset();
 #ifdef MRSID_J2K
@@ -1257,9 +1269,21 @@
         poDS->poImageReader = new LTIDLLReader<J2KImageReader>( oFileSpec, true );
     else
 #endif
+#if defined(LTI_SDK_MAJOR) && LTI_SDK_MAJOR >= 7
+    {
+        poDS->poImageReader = MrSIDImageReader::create();
+    }
+
+    eStat = poDS->poImageReader->initialize( oFileSpec, true );
+#else
+    {
         poDS->poImageReader = new LTIDLLReader<MrSIDImageReader>( oFileSpec, false );
+    }
+
+    eStat = poDS->poImageReader->initialize();
+#endif
 
-    if ( !LT_SUCCESS( poDS->poImageReader->initialize() ) )
+    if ( !LT_SUCCESS(eStat) )
     {
         delete poDS;
         CPLError( CE_Failure, CPLE_AppDefined,
