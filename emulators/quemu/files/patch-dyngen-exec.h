diff -urN dyngen-exec.h qemu-0.6.0-2/dyngen-exec.h
--- dyngen-exec.h	Sat Jul 10 20:20:09 2004
+++ qemu-0.6.0-2/dyngen-exec.h	Thu Jul 15 15:10:51 2004
@@ -197,7 +197,11 @@
 #define PARAM2 ({ int _r; asm("" : "=r"(_r) : "0" (&__op_param2)); _r; })
 #define PARAM3 ({ int _r; asm("" : "=r"(_r) : "0" (&__op_param3)); _r; })
 #else
+#ifdef __APPLE__
+static int __op_param1, __op_param2, __op_param3;
+#else
 extern int __op_param1, __op_param2, __op_param3;
+#endif
 #define PARAM1 ((long)(&__op_param1))
 #define PARAM2 ((long)(&__op_param2))
 #define PARAM3 ((long)(&__op_param3))

