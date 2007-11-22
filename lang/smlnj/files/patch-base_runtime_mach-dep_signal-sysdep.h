--- runtime/mach-dep/signal-sysdep.h.orig	2007-11-04 17:57:27.000000000 -0800
+++ runtime/mach-dep/signal-sysdep.h	2007-11-04 17:56:20.000000000 -0800
@@ -506,8 +506,13 @@
 #    define INT_OVFLW(s, c)	(((s) == SIGFPE) && ((c) == FPE_FLTOVF))
     /* see /usr/include/mach/i386/thread_status.h */
 #    define SIG_GetCode(info,scp)	((info)->si_code)
+#if __DARWIN_UNIX03
+#    define SIG_GetPC(scp)		((scp)->uc_mcontext->__ss.__eip)
+#    define SIG_SetPC(scp, addr)	{ (scp)->uc_mcontext->__ss.__eip = (int) addr; }
+#else
 #    define SIG_GetPC(scp)		((scp)->uc_mcontext->ss.eip)
 #    define SIG_SetPC(scp, addr)	{ (scp)->uc_mcontext->ss.eip = (int) addr; }
+#endif
 #    define SIG_ZeroLimitPtr(scp)	{ ML_X86Frame[LIMITPTR_X86OFFSET] = 0; }
 
 #  else
