
$FreeBSD: /repoman/r/pcvs/ports/net-mgmt/nfdump/files/patch-ft2nfdump.c,v 1.2 2006/11/01 09:09:36 miwi Exp $

--- ft2nfdump.c.orig
+++ ft2nfdump.c
@@ -64,7 +64,7 @@
 #endif
 
 #include "version.h"
-#include "ftbuild.h"
+/*#include "ftbuild.h"*/
 #include "nf_common.h"
 #include "nffile.h"
 #include "launch.h"
