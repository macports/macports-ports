--- acl2-check.lisp.sav	Fri Oct 25 10:32:19 2002
+++ acl2-check.lisp	Fri Apr 25 16:02:42 2003
@@ -141,7 +141,8 @@
 (dotimes (i 256)
          (let ((ch (code-char i)))
            (or (equal (standard-char-p ch)
-                      (or (= i #-mcl 10 #+mcl 13)
+                      ;;(or (= i #-mcl 10 #+mcl 13)
+                      (or (= i 10)
                           (and (>= i 32)
                                (<= i 126))))
                (error "This Common Lisp is unsuitable for ACL2 because ~
@@ -197,7 +198,7 @@
 ; the symbol.  In fact, :UNIX is not a member of *features* in gcl; LISP:UNIX
 ; is.
 
-#-(or unix apple mswindows)
+#-(or unix darwin apple mswindows)
 (error "This Common Lisp is unsuitable for ACL2 because~%~
         neither :UNIX nor :APPLE nor :MSWINDOWS is a member of *features*.")
 
