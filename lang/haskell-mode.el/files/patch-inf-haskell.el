--- inf-haskell.el.sav	Wed Dec  1 21:23:49 2004
+++ inf-haskell.el	Wed Dec  1 21:24:56 2004
@@ -33,12 +33,11 @@
 
 ;; Here I depart from the inferior-haskell- prefix.
 ;; Not sure if it's a good idea.
-(defcustom haskell-program-name "hugs \"+.\""
+(defcustom haskell-program-name "ghci-program-path"
   "The name of the command to start the inferior Haskell process.
 The command can include arguments."
-  :options '("hugs \"+.\"" "ghci")
   :group 'haskell
-  :type '(choice string (repeat string)))
+  :type 'string)
 
 (defconst inferior-haskell-error-regexp-alist
   ;; The format of error messages used by Hugs.
