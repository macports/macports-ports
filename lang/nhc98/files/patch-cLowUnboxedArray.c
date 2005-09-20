--- src/prelude/BinArray/cLowUnboxedArray.c.sav	2005-09-18 21:43:09.000000000 -0400
+++ src/prelude/BinArray/cLowUnboxedArray.c	2005-09-18 21:43:31.000000000 -0400
@@ -1,5 +1,5 @@
-#include "cLowUnboxedArray.h"
 #include <stdlib.h>
+#include "cLowUnboxedArray.h"
 
 void finaliseUBA (UBA uba) {
   free(uba->block);
