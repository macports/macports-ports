--- emacs/src/s/darwin.h	Tue Nov 30 06:57:27 2004
+++ emacs/src/s/darwin.h.new	Wed Jan 12 19:30:53 2005
@@ -261,7 +261,7 @@
    end of the header for adding load commands.  Needed for dumping.
    0x690 is the total size of 30 segment load commands (at 56
    each).  */
-#define LD_SWITCH_SYSTEM_TEMACS -prebind LIBS_CARBON -Xlinker -headerpad -Xlinker 690
+#define LD_SWITCH_SYSTEM_TEMACS -prebind LIBS_CARBON -Xlinker -headerpad -Xlinker E00
 
 #define C_SWITCH_SYSTEM_TEMACS -Dtemacs
 
