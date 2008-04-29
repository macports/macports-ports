--- lisp/idutils.el.orig	2008-04-27 23:02:05.000000000 -0700
+++ lisp/idutils.el	2008-04-27 23:04:26.000000000 -0700
@@ -34,7 +34,7 @@
 (require 'compile)
 (provide 'idutils)
 
-(defvar gid-command "gid" "The command run by the gid function.")
+(defvar gid-command "gid32" "The command run by the gid function.")
 
 (defun gid (args)
   "Run gid, with user-specified ARGS, and collect output in a buffer.
