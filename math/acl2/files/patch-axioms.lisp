--- axioms.lisp.sav	Sun Mar 14 22:14:49 2004
+++ axioms.lisp	Sun Mar 14 22:16:27 2004
@@ -643,11 +643,11 @@
 ; explains why the code below is so cumbersome.
 
                 #+(and non-standard-analysis mcl)
-                "ACL2 Version 2.7(r)(mcl)"
+                "ACL2 Version 2.7(r)(mcl) Built with patches from darwinports to work with OpenMCL (not part of the official distribution)"
                 #+(and non-standard-analysis (not mcl))
                 "ACL2 Version 2.7(r)"
                 #+(and (not non-standard-analysis) mcl)
-                "ACL2 Version 2.7(mcl)"
+                "ACL2 Version 2.7(mcl) Built with patches from darwinports to work with OpenMCL (not part of the official distribution)"
                 #+(and (not non-standard-analysis) (not mcl))
                 "ACL2 Version 2.7")
 
@@ -17472,7 +17472,7 @@
            #+unix :unix
            #+apple :apple
            #+mswindows :mswindows
-           #-(or unix apple mswindows) nil)
+           #-(or unix darwin apple mswindows) nil)
     (packages-created-by-defpkg . nil)
     (print-doc-start-column . 15)
     (prompt-function . default-print-prompt)
