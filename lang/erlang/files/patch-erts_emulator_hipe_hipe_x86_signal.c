--- erts/emulator/hipe/hipe_x86_signal.c.orig	2007-06-18 22:30:20.000000000 -0700
+++ erts/emulator/hipe/hipe_x86_signal.c	2007-06-18 22:36:55.000000000 -0700
@@ -256,7 +256,11 @@
  */
 static void hipe_sigaltstack(void *ss_sp)
 {
+#if __DARWIN_UNIX03
+    stack_t ss;
+#else
     struct sigaltstack ss;
+#endif
 
     ss.ss_sp = ss_sp;
     ss.ss_flags = SS_ONSTACK;
