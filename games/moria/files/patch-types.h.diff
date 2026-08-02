--- source/types.h	1994-07-21 21:47:49.000000000 -0400
+++ source/types.h	2011-12-30 17:25:47.000000000 -0500
@@ -6,11 +6,12 @@
    not for profit purposes provided that this copyright and statement are
    included in all such copies. */
 
-typedef unsigned long  int32u;
-typedef long	       int32;
-typedef unsigned short int16u;
-typedef short	       int16;
-typedef unsigned char  int8u;
+#include <inttypes.h>
+typedef uint32_t  	int32u;
+typedef int32_t		int32;
+typedef uint16_t	int16u;
+typedef int16_t		int16;
+typedef uint8_t		int8u;
 /* some machines will not accept 'signed char' as a type, and some accept it
    but still treat it like an unsigned character, let's just avoid it,
    any variable which can ever hold a negative value must be 16 or 32 bits */
