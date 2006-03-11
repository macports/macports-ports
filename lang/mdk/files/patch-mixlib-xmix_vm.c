--- mixlib/xmix_vm.c.orig	2005-09-21 18:11:04.000000000 +0200
+++ mixlib/xmix_vm.c	2005-09-21 18:12:23.000000000 +0200
@@ -23,6 +23,10 @@
 
 #include "xmix_vm.h"
 
+/* darwin patch... ? */
+#undef G_INLINE_FUNC
+#define G_INLINE_FUNC
+
 /* auxiliar functions */
 G_INLINE_FUNC mix_address_t
 get_M_ (const mix_vm_t *vm, const mix_ins_t *ins);
