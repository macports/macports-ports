--- plugins/maxima/lisp/texmacs-maxima-5.9.2.lisp.sav	2006-03-31 10:39:53.000000000 -0500
+++ plugins/maxima/lisp/texmacs-maxima-5.9.2.lisp	2006-03-31 10:40:48.000000000 -0500
@@ -5,7 +5,7 @@
 (setf *alt-display2d* 'texmacs)
 (setf *prompt-prefix* "channel:promptlatex:\\red ")
 (setf *prompt-suffix* "\\black")
-(setf *general-display-prefix* "verbatim:")
+;(setf *general-display-prefix* "verbatim:")
 (setf *maxima-prolog* "verbatim:")
 (setf *maxima-epilog* "latex:\\red The end\\black")
 #-gcl(setf *debug-io* (make-two-way-stream *standard-input* *standard-output*))
@@ -19,32 +19,6 @@
   (format () "~A(~A~D) ~A" *prompt-prefix* 
     (tex-stripdollar $inchar) $linenum *prompt-suffix*))
 
-(defun retrieve (msg flag &aux (print? nil))
-  (declare (special msg flag print?))
-  (or (eq flag 'noprint) (setq print? t))
-  (cond ((not print?) 
-	 (setq print? t)
-	 (princ *prompt-prefix*)
-	 (princ *prompt-suffix*))
-	((null msg)
-	 (princ *prompt-prefix*)
-	 (princ *prompt-suffix*))
-	((atom msg) 
-	 (format t "~a~a~a" *prompt-prefix* msg *prompt-suffix*) 
-	 (mterpri))
-	((eq flag t)
-	 (princ *prompt-prefix*) 
-	 (mapc #'princ (cdr msg)) 
-	 (princ *prompt-suffix*)
-	 (mterpri))
-	(t 
-	 (princ *prompt-prefix*)
-	 (displa msg) 
-	 (princ *prompt-suffix*)
-	 (mterpri)))
-  (let ((res (mread-noprompt *query-io* nil)))
-       (princ *general-display-prefix*) res))
-
 (declare-top
 	 (special lop rop ccol $gcprint $inchar)
 	 (*expr tex-lbp tex-rbp))
