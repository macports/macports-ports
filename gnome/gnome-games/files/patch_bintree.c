--- gnect/src/bintree.c.org	Sat Jul 26 15:13:10 2003
+++ gnect/src/bintree.c	Sat Jul 26 15:13:28 2003
@@ -24,7 +24,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <malloc.h>
+#include <sys/malloc.h>
 
 #include "connect4.h"
 #include "con4vals.h"
