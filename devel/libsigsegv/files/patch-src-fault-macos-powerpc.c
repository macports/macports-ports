--- src/fault-macos-powerpc.c.orig Mon Sep 30 03:46:54 2002
+++ src/fault-macos-powerpc.c	Tue Aug 10 21:17:54 2004
@@ -31,10 +31,11 @@
 #define EXTRACT_DISP(iw)    ((short *) &(iw))[1]
 
 static void *
-get_fault_addr (struct sigcontext *scp)
+get_fault_addr (struct sigcontext *scp,unsigned int *ir)
 {
-  unsigned int instr = *((unsigned int *) scp->sc_ir);
-  unsigned int *regs = &((unsigned int *) scp->sc_regs)[2];
+  unsigned int instr = *ir;
+  unsigned int *regs = & ((struct ucontext *)scp)->uc_mcontext->ss.r0	;
+     	
   int disp = 0;
   int tmp;
   unsigned int baseA = 0;
@@ -42,6 +43,7 @@
   unsigned int addr;
   unsigned int alignmask = 0xFFFFFFFF;
 
+
   switch (EXTRACT_OP1 (instr))
     {
     case 38:   /* stb */
@@ -56,8 +58,10 @@
     case 36:   /* stw */
     case 37:   /* stwu */
       tmp = EXTRACT_REGA (instr);
+
+
       if (tmp > 0)
-	baseA = regs[tmp];
+		baseA = regs[tmp];
       disp = EXTRACT_DISP (instr);
       break;
     case 31:
@@ -120,5 +124,6 @@
 
   addr = (baseA + baseB) + disp;
   addr &= alignmask;
+
   return (void *) addr;
 }
