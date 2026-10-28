Index: src/cpu/core_dynrec/risc_x64.h
===================================================================
--- src/cpu/core_dynrec/risc_x64.h	(revision 3775)
+++ src/cpu/core_dynrec/risc_x64.h	(working copy)
@@ -85,7 +85,8 @@
 
 static INLINE void gen_reg_memaddr(HostReg reg,void* data) {
 	Bit64s diff = (Bit64s)data-((Bit64s)cache.pos+5);
-	if ((diff<0x80000000LL) && (diff>-0x80000000LL)) {
+	if ((Bit64u)diff<0x0000000080000000ULL ||
+	    (Bit64u)diff>0xffffffff80000000ULL) {
 		cache_addb(0x05+(reg<<3));
 		// RIP-relative addressing is offset after the instruction 
 		cache_addd((Bit32u)(((Bit64u)diff)&0xffffffffLL));
