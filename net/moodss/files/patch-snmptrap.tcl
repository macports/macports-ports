--- snmptrap/snmptrap.tcl.org	2006-04-10 13:00:46.000000000 -0700
+++ snmptrap/snmptrap.tcl	2006-05-06 09:48:05.000000000 -0700
@@ -1,157 +1 @@
-# copyright (C) 1997-2006 Jean-Luc Fontaine (mailto:jfontain@free.fr)
-# this program is free software: please read the COPYRIGHT file enclosed in this package or use the Help Copyright menu
-
-# $Id: patch-snmptrap.tcl,v 1.1 2006/05/08 05:01:57 markd Exp $
-
-
-package provide snmptrap [lindex {$Revision: 1.1 $} 1]
-package require Tnm 2.1.10
-
-namespace eval snmptrap {
-
-    variable numberOfRows 10                                                                                           ;# by default
-
-    array set data {
-        updates 0
-        0,label {} 0,type integer 0,message {row creation order}
-        1,label days 1,type integer 1,message {number of days of uptime for agent}
-        2,label time 2,type dictionary 2,message {uptime for agent (hours:minutes:seconds.hundredths)}
-        3,label type 3,type dictionary 3,message {trap type}
-        4,label identifiers 4,type dictionary 4,message {additional object identifiers} 4,anchor left
-        5,label values 5,type dictionary 5,message {additional object values} 5,anchor left
-        switches {-a 1 --address 1 --mibs 1 --port 1 --rows 1 --trace 0 --version 1}
-        pollTimes -10
-    }
-    set file [open snmptrap.htm]
-    set data(helpText) [read $file]                                                           ;# initialize HTML help data from file
-    close $file
-    unset file
-
-    proc reportError {identifier message} {
-        if {[string length $identifier] > 0} {
-            set text "mib: [mib file $identifier]\n"
-        }
-        append text $message
-        error $text
-    }
-
-    proc printErrorAndExit {identifier message} {
-        puts -nonewline stderr {snmptrap module:}
-        if {[string length $identifier] > 0} {
-            puts -nonewline stderr " (mib: [mib file $identifier])"
-        }
-        puts stderr " $message"
-        exit 1
-    }
-
-    proc initialize {optionsName} {
-        upvar 1 $optionsName options
-        variable data
-        variable session
-        variable trace
-        variable numberOfRows
-
-        catch {set trace $options(--trace)}
-        if {[info exists options(--mibs)]} {                                               ;# comma separated list of MIB file names
-            foreach file [split $options(--mibs) ,] {
-                if {[catch {mib load $file} message]} {
-                    reportError {} $message
-                }
-            }
-        }
-        set arguments {}
-        catch {set arguments [list -address $options(-a)]}
-        catch {set arguments [list -address $options(--address)]}                                               ;# favor long option
-        if {[catch {lappend arguments -port $options(--port)}]} {
-            lappend arguments -port 162                                                                    ;# default SNMP trap port
-        }
-        set type trap                                                                                    ;# for default SNMP version
-        if {[info exists options(--version)]} {                                                     ;# default is 1 (SNMP version 1)
-            switch $options(--version) {
-                1 {}
-                2C {
-                    set type inform
-                    lappend arguments -version SNMPv2C
-                }
-                2U {
-                    set type inform
-                    lappend arguments -version SNMPv2U
-                }
-                default {
-                    reportError {} {version must be 1, 2C or 2U}
-                }
-            }
-        }
-        set session [eval snmp session $arguments]
-        if {[catch {$session bind {} $type {::snmptrap::processTrap %E [list %V]}} message]} {
-            append message "\n(check that Scotty straps daemon is running)."
-            reportError {} $message
-        }
-        set data(identifier) "snmptrap([$session cget -address])"
-        catch {set numberOfRows $options(--rows)}
-    }
-
-    proc formattedObjects {list} {                                                                               ;# list of varbinds
-        set string {}
-        foreach object $list {
-            foreach {identifier type value} $object {}
-            append string " [mib name $identifier]($value)"
-        }
-        return $string
-    }
-
-    proc processTrap {status objects} {       ;# objects are a list of varbinds (see snmp manual page) belonging to the same row
-        variable session
-        variable trace
-        variable data
-        variable numberOfRows
-
-        if {[info exists trace]} {
-            puts "<<< trap($status):[formattedObjects $objects]"
-        }
-        if {[string compare $status noError]} {
-            flashMessage "error: $status from [$session cget -address]"
-            return                                                                                                           ;# done
-        }
-        for {set row [expr {[llength [array names data *,0]] - 1}]} {$row >= 0} {incr row -1} {          ;# shift existing rows down
-            if {($numberOfRows > 0) && ($row >= ($numberOfRows - 1))} continue                      ;# possibly limit number of rows
-            set next [expr {$row + 1}]
-            array set data [list\
-                $next,0 $next $next,1 $data($row,1) $next,2 $data($row,2) $next,3 $data($row,3) $next,4 $data($row,4)\
-                $next,5 $data($row,5)\
-            ]
-        }
-        set data(0,0) 0
-        foreach {identifier type value} [lindex $objects 0] {}
-        scan $value {%ud %s} data(0,1) data(0,2)
-        foreach {identifier type value} [lindex $objects 1] {}                                                          ;# trap type
-        if {[catch {set data(0,3) [mib name $value]} message]} {                                   ;# convert to trap readable value
-            append message "\n(check that MIB including this trap is loaded)."
-            printErrorAndExit $value $message
-        }
-        set identifiers {}
-        set values {}
-        foreach object [lrange $objects 2 end] {                                                   ;# now process additional objects
-            foreach {identifier type value} $object {}
-            if {[string length $identifiers] > 0} {                                                ;# display data in multiple lines
-                append identifiers \n
-                append values \n
-            }
-            if {[catch {regsub {\.0$} [mib name $identifier] {} identifier} message]} {                 ;# possibly strip identifier
-                printErrorAndExit {} $message                                                        ;# abort on invalid identifiers
-            }
-            append identifiers $identifier
-            append values $value
-        }
-        set data(0,4) $identifiers
-        set data(0,5) $values
-        incr data(updates)
-    }
-
-    proc terminate {} {
-        variable session
-
-        catch {$session destroy}                                                                ;# try to clean up and ignore errors
-    }
-
-}
+# copyright (C) 1997-2006 Jean-Luc Fontaine (mailto:jfontain@free.fr)
# this program is free software: please read the COPYRIGHT file enclosed in this package or use the Help Copyright menu

# $Id: patch-snmptrap.tcl,v 1.1 2006/05/08 05:01:57 markd Exp $


package provide snmptrap [lindex {$Revision: 1.1 $} 1]
set version [package require Tnm]
if {[package vcompare $version 2.1.10] < 0} {
    error {Tnm version 2.1.10 or above is required}
}
set tnm3 [expr {[package vcompare $version 3] >= 0}]                                                            ;# tested on windows
if {$tnm3} {                                                                                  ;# commands are in their own namespace
    namespace import Tnm::*
}

namespace eval snmptrap {

    variable numberOfRows 10                                                                                           ;# by default

    array set data {
        updates 0
        0,label {} 0,type integer 0,message {row creation order}
        1,label days 1,type integer 1,message {number of days of uptime for agent}
        2,label time 2,type dictionary 2,message {uptime for agent (hours:minutes:seconds.hundredths)}
        3,label type 3,type dictionary 3,message {trap type}
        4,label identifiers 4,type dictionary 4,message {additional object identifiers} 4,anchor left
        5,label values 5,type dictionary 5,message {additional object values} 5,anchor left
        switches {--mibs 1 --rows 1 --trace 0 --version 1}
        pollTimes -10
    }
    set file [open snmptrap.htm]
    set data(helpText) [read $file]                                                           ;# initialize HTML help data from file
    close $file
    unset file

    proc reportError {identifier message} {
        if {[string length $identifier] > 0} {
            set text "mib: [mib file $identifier]\n"
        }
        append text $message
        error $text
    }

    proc printErrorAndExit {identifier message} {
        puts -nonewline stderr {snmptrap module:}
        if {[string length $identifier] > 0} {
            puts -nonewline stderr " (mib: [mib file $identifier])"
        }
        puts stderr " $message"
        exit 1
    }

    proc initialize {optionsName} {
        upvar 1 $optionsName options
        variable data
        variable session
        variable trace
        variable numberOfRows

        catch {set trace $options(--trace)}
        if {[info exists options(--mibs)]} {                                               ;# comma separated list of MIB file names
            foreach file [split $options(--mibs) ,] {
                if {[catch {mib load $file} message]} {
                    reportError {} $message
                }
            }
        }
        set arguments {}
        set type trap                                                                                    ;# for default SNMP version
        if {[info exists options(--version)]} {                                                     ;# default is 1 (SNMP version 1)
            switch $options(--version) {
                1 {}
                2C {
                    set type inform
                    lappend arguments -version SNMPv2C
                }
                2U {
                    set type inform
                    lappend arguments -version SNMPv2U
                }
                default {
                    reportError {} {version must be 1, 2C or 2U}
                }
            }
        }
        if {$::tnm3} {
            set session [eval snmp listener $arguments]
            set daemon nmtrapd
            set error [catch {$session bind $type {::snmptrap::processTrap %E [list %V]}} message]
        } else {
            set session [eval snmp session $arguments]
            set daemon straps
            set error [catch {$session bind {} $type {::snmptrap::processTrap %E [list %V]}} message]
        }
        if {$error} {
            append message "\n(check that Scotty $daemon daemon is running)."
            reportError {} $message
        }
        catch {set numberOfRows $options(--rows)}
    }

    proc formattedObjects {list} {                                                                               ;# list of varbinds
        set string {}
        foreach object $list {
            foreach {identifier type value} $object {}
            append string " [mib name $identifier]($value)"
        }
        return $string
    }

    proc processTrap {status objects} {           ;# objects are a list of varbinds (see snmp manual page) belonging to the same row
        variable session
        variable trace
        variable data
        variable numberOfRows

        if {[info exists trace]} {
            puts "<<< trap($status):[formattedObjects $objects]"
        }
        if {[string compare $status noError]} {
            flashMessage "error: $status"
            return                                                                                                           ;# done
        }
        for {set row [expr {[llength [array names data *,0]] - 1}]} {$row >= 0} {incr row -1} {          ;# shift existing rows down
            if {($numberOfRows > 0) && ($row >= ($numberOfRows - 1))} continue                      ;# possibly limit number of rows
            set next [expr {$row + 1}]
            array set data [list\
                $next,0 $next $next,1 $data($row,1) $next,2 $data($row,2) $next,3 $data($row,3) $next,4 $data($row,4)\
                $next,5 $data($row,5)\
            ]
        }
        set data(0,0) 0
        foreach {identifier type value} [lindex $objects 0] {}
        scan $value {%ud %s} data(0,1) data(0,2)
        foreach {identifier type value} [lindex $objects 1] {}                                                          ;# trap type
        if {[catch {set data(0,3) [mib name $value]} message]} {                                   ;# convert to trap readable value
            append message "\n(check that MIB including this trap is loaded)."
            printErrorAndExit $value $message
        }
        set identifiers {}
        set values {}
        foreach object [lrange $objects 2 end] {                                                   ;# now process additional objects
            foreach {identifier type value} $object {}
            if {[string length $identifiers] > 0} {                                                ;# display data in multiple lines
                append identifiers \n
                append values \n
            }
            if {[catch {regsub {\.0$} [mib name $identifier] {} identifier} message]} {                 ;# possibly strip identifier
                printErrorAndExit {} $message                                                        ;# abort on invalid identifiers
            }
            append identifiers $identifier
            append values $value
        }
        set data(0,4) $identifiers
        set data(0,5) $values
        incr data(updates)
    }

    proc terminate {} {
        variable session

        catch {$session destroy}                                                                ;# try to clean up and ignore errors
    }

}
\ No newline at end of file
