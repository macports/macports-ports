--- interface-raw.lisp.sav	Thu Oct 31 12:37:25 2002
+++ interface-raw.lisp	Fri Apr 25 16:06:50 2003
@@ -2760,7 +2760,9 @@
   #+(AND (not DRAFT-ANSI-CL-2) (not CLTL2) (not clisp))
   `(lisp::special-form-p ,name)
   #+(or DRAFT-ANSI-CL-2 cmu clisp)
-  `(special-operator-p ,name))
+  `(special-operator-p ,name)
+  #+openmcl
+  `(common-lisp::special-operator-p ,name))
 
 (defun virginp (name new-type)
   (and (symbolp name)
@@ -4345,7 +4347,7 @@
 ; is compiled in that Lisp; so we avoid it for MCL.  It was originally in
 ; acl2-init.lisp, but cmulisp warned that *open-output-channel-key*,
 ; print-idate, and idate were undefined.
-#-mcl
+
 (defun saved-build-date-string ()
   (with-output-to-string
    (str)
