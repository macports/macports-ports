--- ddd/logplayer.C.orig	Thu Jun 19 12:28:21 2003
+++ ddd/logplayer.C	Thu Jun 19 12:29:31 2003
@@ -43,7 +43,17 @@
 #include "streampos.h"
 
 #include <iostream.h>
-#include <fstream.h>
+
+#if 0
+#include <fstream.h>  XXX work-around a bug in Mac OS X fstream.h
+#else
+#include <fstream>
+using std::filebuf;
+using std::ifstream;
+using std::ofstream;
+using std::fstream;
+#endif
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
