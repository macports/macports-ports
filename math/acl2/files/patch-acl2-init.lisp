--- acl2-init.lisp.sav	Sun Nov  3 11:31:49 2002
+++ acl2-init.lisp	Fri Apr 25 16:04:10 2003
@@ -86,13 +86,13 @@
                 (x arguments)
                 (setq result (concatenate 'string result " " x)))
                result))
-  #+cmu
+  #+(or cmu openmcl)
   (common-lisp-user::run-program string arguments :output t)
   #+clisp
   (ext:run-program string :arguments arguments)
-  #-(or akcl lucid lispworks allegro cmu clisp)
+  #-(or akcl lucid lispworks allegro cmu openmcl clisp)
   (declare (ignore string arguments))
-  #-(or akcl lucid lispworks allegro cmu clisp)
+  #-(or akcl lucid lispworks allegro cmu openmcl clisp)
   (error "SYSTEM-CALL is not yet defined in this Lisp."))
 
 (defun copy-acl2 (dir)
@@ -743,7 +743,7 @@
 
 ; Since saved-build-date-string is avoided for MCL, we avoid the following too
 ; (which is not applicable to MCL sessions anyhow).
-#-mcl
+
 (defun save-acl2 (&optional mode other-info
                             
 ; Currently do-not-save-gcl is ignored for other than GCL.  It was added in
@@ -797,7 +797,9 @@
     (save-acl2-in-cmulisp "nsaved_acl2" mode other-info)
     #+clisp
     (save-acl2-in-clisp "nsaved_acl2" mode other-info)
-    #-(or akcl lucid lispworks allegro clisp)
+    #+openmcl
+    (ccl::save-application "nsaved_acl2")
+    #-(or akcl lucid lispworks allegro clisp openmcl)
     (error "We do not know how to save ACL2 in this Common Lisp.")
     (format t "Saving of ACL2 is complete.~%")))
 
