--- src/interfaces/curses/widgets/wdg.h.orig	2005-05-27 17:11:45.000000000 +0200
+++ src/interfaces/curses/widgets/wdg.h	2007-11-15 10:15:05.000000000 +0100
@@ -11,8 +11,9 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/types.h>

 #ifdef OS_WINDOWS
    #include <windows.h>
 #endif

