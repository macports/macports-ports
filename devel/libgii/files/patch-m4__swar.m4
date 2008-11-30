--- m4/swar.m4	2005/07/12 12:42:46	1.11
+++ m4/swar.m4	2007/06/03 06:39:38	1.11.2.1
@@ -34,7 +34,10 @@
 	#ifdef _MSC_VER
 	__asm cpuid
 	#else
-	asm("cpuid": "=a" (a), "=b" (b), "=c" (c), "=d" (d) : "a" (in));
+	asm("mov %%ebx, %%esi\n\t"
+	    "cpuid\n\t"
+	    "xchg %%esi, %%ebx\n\t"
+	    : "=a" (a), "=S" (b), "=c" (c), "=d" (d) : "a" (in));
 	#endif
 	return d;],
 	ggi_cv_cc_can_cpuid="yes", ggi_cv_cc_can_cpuid="no")])
