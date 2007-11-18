diff -u -r1.2 signals_asm.c
--- asmrun/signals_asm.c	1 Mar 2007 10:27:26 -0000	1.2
+++ asmrun/signals_asm.c	6 Nov 2007 16:17:00 -0000
@@ -238,7 +238,7 @@
   /* Stack overflow handling */
 #ifdef HAS_STACK_OVERFLOW_DETECTION
   {
-    struct sigaltstack stk;
+    stack_t stk;
     struct sigaction act;
     stk.ss_sp = sig_alt_stack;
     stk.ss_size = SIGSTKSZ;
