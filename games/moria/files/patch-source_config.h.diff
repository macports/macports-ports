--- source/config.h.orig	2006-09-12 20:34:36.000000000 -0400
+++ source/config.h	2006-09-12 20:41:56.000000000 -0400
@@ -6,6 +6,10 @@
    not for profit purposes provided that this copyright and statement are
    included in all such copies. */
 
+#define unix
+#include <sys/ioctl_compat.h>
+#include <unistd.h>
+
 #define CONFIG_H_INCLUDED
 #ifdef CONSTANT_H_INCLUDED
 Constant.h should always be included after config.h, because it uses
@@ -200,16 +204,16 @@
 
 /* This must be unix; change MORIA_LIB as appropriate.  */
 #define MORIA_SAV	"moria.save"
-#define MORIA_LIB(xxx)  "/home/math/grabiner/moria/files/xxx"
-#define MORIA_HOU	MORIA_LIB(hours)
-#define MORIA_MOR	MORIA_LIB(news)
-#define MORIA_TOP	MORIA_LIB(scores)
-#define MORIA_HELP	MORIA_LIB(roglcmds.hlp)
-#define MORIA_ORIG_HELP	MORIA_LIB(origcmds.hlp)
-#define MORIA_WIZ_HELP	MORIA_LIB(rwizcmds.hlp)
-#define MORIA_OWIZ_HELP	MORIA_LIB(owizcmds.hlp)
-#define MORIA_WELCOME	MORIA_LIB(welcome.hlp)
-#define MORIA_VER	MORIA_LIB(version.hlp)
+
+#define MORIA_HOU	"/home/math/grabiner/moria/files/hours"
+#define MORIA_MOR	"home/math/grabiner/moria/files/news"
+#define MORIA_TOP	"/home/math/grabiner/moria/files/scores"
+#define MORIA_HELP	"/home/math/grabiner/moria/files/roglcmds.hlp"
+#define MORIA_ORIG_HELP	"/home/math/grabiner/moria/files/origcmds.hlp"
+#define MORIA_WIZ_HELP	"/home/math/grabiner/moria/files/rwizcmds.hlp"
+#define MORIA_OWIZ_HELP	"/home/math/grabiner/moria/files/owizcmds.hlp"
+#define MORIA_WELCOME	"/home/math/grabiner/moria/files/welcome.hlp"
+#define MORIA_VER	"/home/math/grabiner/moria/files/version.hlp"
 
 #endif
 #endif
