--- avilib-0.6.10/avidump.c.old	Fri Apr  9 15:51:08 2004
+++ avilib-0.6.10/avidump.c	Fri Apr  9 15:51:09 2004
@@ -57,7 +57,7 @@
                    ((x<<8)  & 0x00ff0000) |\
                    ((x<<24) & 0xff000000))
 # define SWAP8(x) (( (SWAP4(x)<<32) & 0xffffffff00000000ULL) |\
-                   ( SWAP4(x))
+                   ( SWAP4(x)))
 #else
 # define SWAP2(a) (a)
 # define SWAP4(a) (a)
