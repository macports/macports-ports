--- gnect/src/pbsolver.c.org	Sat Jul 26 15:28:31 2003
+++ gnect/src/pbsolver.c	Sat Jul 26 15:28:43 2003
@@ -24,7 +24,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <malloc.h>
+#include <sys/malloc.h>
 
 #include "connect4.h"
 #include "con4vals.h"
