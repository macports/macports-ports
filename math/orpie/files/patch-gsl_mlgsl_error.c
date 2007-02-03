--- gsl/mlgsl_error.c.orig	Sat Oct 29 22:40:23 2005
+++ gsl/mlgsl_error.c	Sun Sep 24 14:42:12 2006
@@ -43,7 +43,8 @@
   exn_arg = alloc_small(2, 0);
   Store_field(exn_arg, 0, Val_int(conv_err_code(gsl_errno)));
   Store_field(exn_arg, 1, copy_string(ml_gsl_exn_msg));
-  CAMLreturn(raise_with_arg(*ml_gsl_exn, exn_arg));
+  raise_with_arg(*ml_gsl_exn, exn_arg);
+  CAMLreturn0;
 }
 
 static void ml_gsl_error_handler(const char *reason, const char *file,
