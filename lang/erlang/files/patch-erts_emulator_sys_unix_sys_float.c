--- erts/emulator/sys/unix/sys_float.c.orig	2007-06-30 19:57:21.000000000 -0700
+++ erts/emulator/sys/unix/sys_float.c	2007-06-30 19:53:01.000000000 -0700
@@ -333,7 +333,11 @@
 #define mc_pc(mc)	((mc)->gregs[REG_EIP])
 typedef mcontext_t *erts_mcontext_ptr_t;
 #elif defined(__DARWIN__) && defined(__i386__)
+#if __DARWIN_UNIX03
+#define mc_pc(mc)	((mc)->__ss.__eip)
+#else
 #define mc_pc(mc)	((mc)->ss.eip)
+#endif
 typedef mcontext_t erts_mcontext_ptr_t;
 #elif defined(__FreeBSD__) && defined(__x86_64__)
 #define mc_pc(mc)	((mc)->mc_rip)
@@ -512,12 +516,21 @@
     regs[PT_FPSCR] = 0x80|0x40|0x10;	/* VE, OE, ZE; not UE or XE */
 #endif
 #elif defined(__DARWIN__) && defined(__i386__)
+#if __DARWIN_UNIX03
+    mcontext_t mc = uc->uc_mcontext;
+    if (mc->__fs.__fpu_mxcsr & 0x000D) {
+	mc->__fs.__fpu_mxcsr &= ~(0x003F|0x0680);
+	skip_sse2_insn(mc);
+    }
+    *(unsigned short *)&mc->__fs.__fpu_fsw &= ~0xFF;
+#else
     mcontext_t mc = uc->uc_mcontext;
     if (mc->fs.fpu_mxcsr & 0x000D) {
 	mc->fs.fpu_mxcsr &= ~(0x003F|0x0680);
 	skip_sse2_insn(mc);
     }
     *(unsigned short *)&mc->fs.fpu_fsw &= ~0xFF;
+#endif
 #elif defined(__DARWIN__) && defined(__ppc__)
     mcontext_t mc = uc->uc_mcontext;
     mc->ss.srr0 += 4;
