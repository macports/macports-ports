--- ubase/uprintf.ml.old	Wed Jul 21 15:00:23 2004
+++ ubase/uprintf.ml	Wed Jul 21 15:00:37 2004
@@ -10,8 +10,8 @@
 (*                                                                     *)
 (***********************************************************************)
 
-external format_int: string -> int -> string = "format_int"
-external format_float: string -> float -> string = "format_float"
+external format_int: string -> int -> string = "caml_format_int"
+external format_float: string -> float -> string = "caml_format_float"
 
 let fprintf outchan doafter format =
   let format = (Obj.magic format : string) in
