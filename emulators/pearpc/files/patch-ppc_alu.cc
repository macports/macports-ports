Index: src/cpu/cpu_generic/ppc_alu.cc
===================================================================
RCS file: /cvsroot/pearpc/pearpc/src/cpu/cpu_generic/ppc_alu.cc,v
retrieving revision 1.3
diff -u -r1.3 ppc_alu.cc
--- src/cpu/cpu_generic/ppc_alu.cc	16 Nov 2004 19:42:42 -0000	1.3
+++ src/cpu/cpu_generic/ppc_alu.cc	24 Dec 2004 19:42:16 -0000
@@ -424,10 +424,12 @@
 	sint32 a = gCPU.gpr[rA];
 	sint32 b = imm;
 	uint32 c;
+#if 0
 	if (!VALGRIND_CHECK_READABLE(a, sizeof a)) {
 		ht_printf("%08x <--i\n", gCPU.pc);
 //		SINGLESTEP("");
 	}
+#endif
 	if (a < b) {
 		c = 8;
 	} else if (a > b) {
