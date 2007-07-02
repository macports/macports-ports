--- Coordinator.cpp.orig	2007-07-02 00:56:11.000000000 -0700
+++ Coordinator.cpp	2007-07-02 02:01:54.000000000 -0700
@@ -28,6 +28,7 @@
 #endif
 
 #include <unistd.h>
+#include <libgen.h>
 
 #include "global.h"
 #include "Coordinator.h"
@@ -130,12 +131,20 @@ void Coordinator::Start()
 
 void Coordinator::GetDestinationDir( char* szBuffer )
 {
+  #if __DARWIN_UNIX03
+	char* szFileName = m_pOptions->getOption( OPTION_NZBFILE, NULL );
+	#else
 	const char* szFileName = m_pOptions->getOption( OPTION_NZBFILE, NULL );
+	#endif
 	
 	if( !strcmp( m_pOptions->getOption( OPTION_APPENDDIR, NULL ), "yes" ) )
 	{
 		char postname[1024];
+		#if __DARWIN_UNIX03
+		char* szBaseName = basename( szFileName );
+		#else
 		const char* szBaseName = basename( szFileName );
+		#endif
 		
 		// if .nzb file has a certain structure, try to strip out certain elements
 		if (sscanf(szBaseName,"msgid_%*d_%1023s", postname) == 1)
