--- tcltk/orig.tkcon.tcl	2008-04-18 11:40:00.000000000 +0200
+++ tcltk/tkcon.tcl	2008-04-18 11:40:11.000000000 +0200
@@ -44,7 +44,7 @@
 if {$tcl_version < 8.0} {
     return -code error "tkcon requires at least Tcl/Tk8"
 } else {
-    package require -exact Tk $tcl_version
+    package require Tk $tcl_version
 }
 
 catch {package require bogus-package-name}
