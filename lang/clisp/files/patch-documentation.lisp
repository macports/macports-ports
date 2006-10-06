--- src/documentation.lisp.sav	2006-10-06 14:01:54.000000000 -0400
+++ src/documentation.lisp	2006-10-06 14:02:09.000000000 -0400
@@ -4,7 +4,7 @@
 
 (in-package "CLOS")
 
-(defun function-documentation (x)
+(defun function-documentation (x &aux name)
   (cond ((typep-class x <standard-generic-function>)
          (std-gf-documentation x))
         ((eq (type-of x) 'FUNCTION) ; interpreted function?
@@ -12,8 +12,7 @@
         #+FFI ((eq (type-of x) 'ffi::foreign-function)
                (getf (sys::%record-ref x 5) :documentation))
         ((sys::closurep x) (sys::closure-documentation x))
-        ((let ((name (sys::subr-info x))) ; subr
-           (and name (get :documentation name))))
+        ((setq name (sys::subr-info x)) (get :documentation name)) ; subr
         (t (get :documentation (sys::%record-ref x 0)))))
 
 ;;; documentation
@@ -81,7 +80,7 @@
   (:method ((x slot-definition) (doc-type (eql 't)))
     (slot-definition-documentation x)))
 
-(defun set-function-documentation (x new-value)
+(defun set-function-documentation (x new-value &aux name)
   (cond ((typep-class x <standard-generic-function>)
          (setf (std-gf-documentation x) new-value))
         ((eq (type-of x) 'FUNCTION) ; interpreted function?
@@ -89,8 +88,8 @@
         #+FFI ((eq (type-of x) 'ffi::foreign-function)
                (setf (getf (sys::%record-ref x 5) :documentation) new-value))
         ((sys::closurep x) (sys::closure-set-documentation x new-value))
-        ((let ((name (sys::subr-info x))) ; subr
-           (and name (setf (get :documentation name) new-value))))
+        ((setq name (sys::subr-info x)) ; subr
+         (setf (get :documentation name) new-value))
         (t                      ; fsubr
          (setf (get :documentation (sys::%record-ref x 0)) new-value))))
 
