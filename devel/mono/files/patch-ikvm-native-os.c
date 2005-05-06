--- ikvm-native/os.c	Fri May  6 04:24:46 2005
+++ ..//../os.c	Fri May  6 04:24:32 2005
@@ -57,6 +57,7 @@
 	}
 #else
 	#include <gmodule.h>
+	#include <sys/types.h>
 	#include <sys/mman.h>
 	#include "jni.h"
 
