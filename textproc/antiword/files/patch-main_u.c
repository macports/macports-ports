--- main_u.c	Thu Oct 14 18:49:18 2004
+++ ../../main_u.c	Sun Jan  2 11:31:57 2005
@@ -29,9 +29,7 @@
 #include <fcntl.h>
 #include <io.h>
 #endif /* __dos */
-#if defined(__STDC_ISO_10646__)
 #include <locale.h>
-#endif /* __STDC_ISO_10646__ */
 #if defined(N_PLAT_NLM)
 #if !defined(_VA_LIST)
 #include "NW-only/nw_os.h"
