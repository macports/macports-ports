--- axioms.lisp.sav	Fri Apr 25 17:07:12 2003
+++ axioms.lisp	Fri Apr 25 17:07:28 2003
@@ -17472,7 +17472,7 @@
            #+unix :unix
            #+apple :apple
            #+mswindows :mswindows
-           #-(or unix apple mswindows) nil)
+           #-(or unix darwin apple mswindows) nil)
     (packages-created-by-defpkg . nil)
     (print-doc-start-column . 15)
     (prompt-function . default-print-prompt)
@@ -19879,7 +19879,7 @@
       str
     (let ((os (os state)))
       (case os
-        (:unix str)
+        (:unix (string-append str *directory-separator-string*))
         ((:apple :mswindows)
          (let ((sep (if (eq os :apple) #\: #\\)))
            (if (position *directory-separator* str)
