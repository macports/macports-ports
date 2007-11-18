diff -u -r1.8 signals_osdep.h
--- asmrun/signals_osdep.h	29 Jan 2007 12:10:52 -0000	1.8
+++ asmrun/signals_osdep.h	6 Nov 2007 16:17:00 -0000
@@ -88,8 +88,13 @@
 
   #include <sys/ucontext.h>
 
-  #define CONTEXT_STATE (((struct ucontext *)context)->uc_mcontext->ss)
-  #define CONTEXT_PC (CONTEXT_STATE.eip)
+  #if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
+    #define CONTEXT_STATE (((ucontext_t *)context)->uc_mcontext->ss)
+    #define CONTEXT_PC (CONTEXT_STATE.eip)
+  #else
+    #define CONTEXT_STATE (((ucontext_t *)context)->uc_mcontext->__ss)
+    #define CONTEXT_PC (CONTEXT_STATE.__eip)
+  #endif
   #define CONTEXT_FAULTING_ADDRESS ((char *) info->si_addr)
 
 /****************** MIPS, all OS */
@@ -113,106 +118,46 @@
 
 #elif defined(TARGET_power) && defined(SYS_rhapsody)
 
-#ifdef __ppc64__
-
   #define DECLARE_SIGNAL_HANDLER(name) \
      static void name(int sig, siginfo_t * info, void * context)
 
-  #define SET_SIGACT(sigact,name) \
-     sigact.sa_sigaction = (name); \
-     sigact.sa_flags = SA_SIGINFO | SA_64REGSET
-
-  typedef unsigned long long context_reg;
-
   #include <sys/ucontext.h>
-
-  #define CONTEXT_STATE (((struct ucontext64 *)context)->uc_mcontext64->ss)
-
-  #define CONTEXT_PC (CONTEXT_STATE.srr0)
-  #define CONTEXT_EXCEPTION_POINTER (CONTEXT_STATE.r29)
-  #define CONTEXT_YOUNG_LIMIT (CONTEXT_STATE.r30)
-  #define CONTEXT_YOUNG_PTR (CONTEXT_STATE.r31)
-  #define CONTEXT_FAULTING_ADDRESS ((char *) info->si_addr)
-  #define CONTEXT_SP (CONTEXT_STATE.r1)
-
-#else
-
-  #include <sys/utsname.h>
-
-  #define DECLARE_SIGNAL_HANDLER(name) \
-     static void name(int sig, siginfo_t * info, void * context)
-
-  #define SET_SIGACT(sigact,name) \
-     sigact.sa_handler = (void (*)(int)) (name); \
-     sigact.sa_flags = SA_SIGINFO
-
-  typedef unsigned long context_reg;
-
-  #define CONTEXT_PC (*context_gpr_p(context, -2))
-  #define CONTEXT_EXCEPTION_POINTER (*context_gpr_p(context, 29))
-  #define CONTEXT_YOUNG_LIMIT (*context_gpr_p(context, 30))
-  #define CONTEXT_YOUNG_PTR (*context_gpr_p(context, 31))
-  #define CONTEXT_FAULTING_ADDRESS ((char *) info->si_addr)
-  #define CONTEXT_SP (*context_gpr_p(context, 1))
-
-  static int ctx_version = 0;
-  static void init_ctx (void)
-  {
-    struct utsname name;
-    if (uname (&name) == 0){
-      if (name.release[1] == '.' && name.release[0] <= '5'){
-        ctx_version = 1;
-      }else{
-        ctx_version = 2;
-      }
-    }else{
-      caml_fatal_error ("cannot determine SIGCONTEXT format");
-    }
-  }
-
-  #ifdef DARWIN_VERSION_6
-    #include <sys/ucontext.h>
-    static unsigned long *context_gpr_p (void *ctx, int regno)
-    {
-      unsigned long *regs;
-      if (ctx_version == 0) init_ctx ();
-      if (ctx_version == 1){
-        /* old-style context (10.0 and 10.1) */
-        regs = (unsigned long *)(((struct sigcontext *)ctx)->sc_regs);
-      }else{
-        Assert (ctx_version == 2);
-        /* new-style context (10.2) */
-        regs = (unsigned long *)&(((struct ucontext *)ctx)->uc_mcontext->ss);
-      }
-      return &(regs[2 + regno]);
-    }
+  
+  #ifdef __LP64__
+    #define SET_SIGACT(sigact,name) \
+       sigact.sa_sigaction = (name); \
+       sigact.sa_flags = SA_SIGINFO | SA_64REGSET
+    
+    typedef unsigned long long context_reg;
+    
+    #define CONTEXT_MCONTEXT (((ucontext64_t *)context)->uc_mcontext64)
   #else
-    #define SA_SIGINFO 0x0040
-    struct ucontext {
-      int       uc_onstack;
-      sigset_t  uc_sigmask;
-      struct sigaltstack uc_stack;
-      struct ucontext   *uc_link;
-      size_t    uc_mcsize;
-      unsigned long     *uc_mcontext;
-    };
-    static unsigned long *context_gpr_p (void *ctx, int regno)
-    {
-      unsigned long *regs;
-      if (ctx_version == 0) init_ctx ();
-      if (ctx_version == 1){
-        /* old-style context (10.0 and 10.1) */
-        regs = (unsigned long *)(((struct sigcontext *)ctx)->sc_regs);
-      }else{
-        Assert (ctx_version == 2);
-        /* new-style context (10.2) */
-        regs = (unsigned long *)((struct ucontext *)ctx)->uc_mcontext + 8;
-      }
-      return &(regs[2 + regno]);
-    }
+    #define SET_SIGACT(sigact,name) \
+       sigact.sa_sigaction = (name); \
+       sigact.sa_flags = SA_SIGINFO
+    
+    typedef unsigned long context_reg;
+    
+    #define CONTEXT_MCONTEXT (((ucontext_t *)context)->uc_mcontext)
   #endif
-
-#endif
+  
+  #if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
+    #define CONTEXT_STATE (CONTEXT_MCONTEXT->ss)
+    #define CONTEXT_PC (CONTEXT_STATE.srr0)
+    #define CONTEXT_EXCEPTION_POINTER (CONTEXT_STATE.r29)
+    #define CONTEXT_YOUNG_LIMIT (CONTEXT_STATE.r30)
+    #define CONTEXT_YOUNG_PTR (CONTEXT_STATE.r31)
+    #define CONTEXT_SP (CONTEXT_STATE.r1)
+  #else
+    #define CONTEXT_STATE (CONTEXT_MCONTEXT->__ss)
+    #define CONTEXT_PC (CONTEXT_STATE.__srr0)
+    #define CONTEXT_EXCEPTION_POINTER (CONTEXT_STATE.__r29)
+    #define CONTEXT_YOUNG_LIMIT (CONTEXT_STATE.__r30)
+    #define CONTEXT_YOUNG_PTR (CONTEXT_STATE.__r31)
+    #define CONTEXT_SP (CONTEXT_STATE.__r1)
+  #endif
+  
+  #define CONTEXT_FAULTING_ADDRESS ((char *) info->si_addr)
 
 /****************** PowerPC, ELF (Linux) */
 
