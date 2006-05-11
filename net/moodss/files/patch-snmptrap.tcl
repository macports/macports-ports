--- snmptrap/snmptrap.tcl.org	2006-05-11 07:38:41.000000000 -0700
+++ snmptrap/snmptrap.tcl	2006-05-11 07:41:14.000000000 -0700
@@ -1,11 +1,18 @@
 # copyright (C) 1997-2006 Jean-Luc Fontaine (mailto:jfontain@free.fr)
 # this program is free software: please read the COPYRIGHT file enclosed in this package or use the Help Copyright menu
 
-# $Id: patch-snmptrap.tcl,v 1.3 2006/05/11 14:41:12 markd Exp $
+# $Id: patch-snmptrap.tcl,v 1.3 2006/05/11 14:41:12 markd Exp $
 
 
 package provide snmptrap [lindex {$Revision: 1.3 $} 1]
-package require Tnm 2.1.10
+set version [package require Tnm]
+if {[package vcompare $version 2.1.10] < 0} {
+    error {Tnm version 2.1.10 or above is required}
+}
+set tnm3 [expr {[package vcompare $version 3] >= 0}]                                                            ;# tested on windows
+if {$tnm3} {                                                                                  ;# commands are in their own namespace
+    namespace import Tnm::*
+}
 
 namespace eval snmptrap {
 
@@ -19,7 +26,7 @@
         3,label type 3,type dictionary 3,message {trap type}
         4,label identifiers 4,type dictionary 4,message {additional object identifiers} 4,anchor left
         5,label values 5,type dictionary 5,message {additional object values} 5,anchor left
-        switches {-a 1 --address 1 --mibs 1 --port 1 --rows 1 --trace 0 --version 1}
+        switches {--mibs 1 --rows 1 --trace 0 --version 1}
         pollTimes -10
     }
     set file [open snmptrap.htm]
@@ -60,11 +67,6 @@
             }
         }
         set arguments {}
-        catch {set arguments [list -address $options(-a)]}
-        catch {set arguments [list -address $options(--address)]}                                               ;# favor long option
-        if {[catch {lappend arguments -port $options(--port)}]} {
-            lappend arguments -port 162                                                                    ;# default SNMP trap port
-        }
         set type trap                                                                                    ;# for default SNMP version
         if {[info exists options(--version)]} {                                                     ;# default is 1 (SNMP version 1)
             switch $options(--version) {
@@ -82,12 +84,19 @@
                 }
             }
         }
-        set session [eval snmp session $arguments]
-        if {[catch {$session bind {} $type {::snmptrap::processTrap %E [list %V]}} message]} {
-            append message "\n(check that Scotty straps daemon is running)."
+        if {$::tnm3} {
+            set session [eval snmp listener $arguments]
+            set daemon nmtrapd
+            set error [catch {$session bind $type {::snmptrap::processTrap %E [list %V]}} message]
+        } else {
+            set session [eval snmp session $arguments]
+            set daemon straps
+            set error [catch {$session bind {} $type {::snmptrap::processTrap %E [list %V]}} message]
+        }
+        if {$error} {
+            append message "\n(check that Scotty $daemon daemon is running)."
             reportError {} $message
         }
-        set data(identifier) "snmptrap([$session cget -address])"
         catch {set numberOfRows $options(--rows)}
     }
 
@@ -100,7 +109,7 @@
         return $string
     }
 
-    proc processTrap {status objects} {       ;# objects are a list of varbinds (see snmp manual page) belonging to the same row
+    proc processTrap {status objects} {           ;# objects are a list of varbinds (see snmp manual page) belonging to the same row
         variable session
         variable trace
         variable data
@@ -110,7 +119,7 @@
             puts "<<< trap($status):[formattedObjects $objects]"
         }
         if {[string compare $status noError]} {
-            flashMessage "error: $status from [$session cget -address]"
+            flashMessage "error: $status"
             return                                                                                                           ;# done
         }
         for {set row [expr {[llength [array names data *,0]] - 1}]} {$row >= 0} {incr row -1} {          ;# shift existing rows down
@@ -155,3 +164,4 @@
     }
 
 }
+
