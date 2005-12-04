--- upcc.pl	2005-10-28 21:39:17.000000000 +0200
+++ upcc.pl	2005-12-03 19:51:09.000000000 +0100
@@ -1791,9 +1791,17 @@
 	    print DST "#pragma upc start_upc_only\n";
 	    print DST "extern const int MYTHREAD;\n";
 	    print DST "extern const int THREADS;\n" unless ($opt_threadcount);
-	    print DST "#if defined(__APPLE__) && defined(__MACH__)\n";
-	    print DST "  #define __asm(X)\n";
-	    print DST "#endif\n";
+            print DST "#if defined(__APPLE__) && defined(__MACH__)\n";
+            print DST "  #define __asm(X)\n"; # fix for fprintf&friends in XCode tools 2.0+
+            print DST "  #if __APPLE_CC__ >= 5026\n"; # fix for OS{Read,Write}SwapInt{16,32} in XCode tools 2.1+
+            print DST "    #define volatile(...)\n";
+            print DST "    #if __APPLE_CC__ >= 5247\n";
+            print DST "      #define __asm__(...)\n";
+            print DST "    #else\n";
+            print DST "      #define __asm__\n";
+            print DST "    #endif\n";
+            print DST "  #endif\n";
+            print DST "#endif\n";
 	    print DST "#pragma upc end_upc_only\n";
 	    print DST "#ifdef __MTA__\n"; # define compiler-specific types used in headers
 	    print DST "  #define __short16 short\n";
