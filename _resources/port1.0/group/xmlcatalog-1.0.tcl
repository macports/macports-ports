# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2013, 2017 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of The MacPorts Project nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# This PortGroup manages global XML catalogs for docbook and other packages
# with xml and sgml catalogs.
# Set name and version as for a normal standalone port,
# then set catalog parameters as described in more detail below.
#
# Usage:
#
# PortGroup xmlcatalog 1.0
# xml.catalog childcatalog
# xml.addtocatalog rootcatalog newcatalog
# sgml.catalog childcatalog
# sgml.addtocatalog rootcatalog newcatalog
#
# where xml.catalog and sgml.catalog will add a new catalog
# to the root catalog and xml.addtocatalog and sgml.addtocatalog
# will add a new catalog to the catalog specified as the first argument.
# Catalogs will be created if they do not exist.

default categories xmlcatalog

global xml.rootdir
set xml.rootdir ${prefix}/etc
global xml.confdir
set xml.confdir ${prefix}/etc/xml
global sgml.confdir
set sgml.confdir ${prefix}/etc/sgml

options xml.catalog
option_proc xml.catalog xml._set_catalog
options xml.addtocatalog
option_proc xml.addtocatalog xml._set_catalog_entry
global xml.rootcatalog xml.catalog_list
set xml.rootcatalog ${xml.confdir}/catalog
set xml.catalog_list {}

options xml.entity
option_proc xml.entity xml._set_entity
global xml.entity_list
set xml.entity_list {}

options xml.rewrite
option_proc xml.rewrite xml._set_rewrite
global xml.rewrite_list
set xml.rewrite_list {}

options sgml.catalog
option_proc sgml.catalog sgml._set_catalog
options sgml.addtocatalog
option_proc sgml.addtocatalog sgml._set_catalog_entry
global sgml.rootcatalog sgml.catalog_list
set sgml.rootcatalog ${sgml.confdir}/catalog
set sgml.catalog_list {}

depends_lib-append port:xmlcatmgr

proc xml._set_catalog {option action args} {
    global xml.catalog_list
    global xml.rootcatalog
    if {$action != "set"} return
    foreach catalog [option ${option}] {
        ui_debug "add catalog ${catalog} to ${xml.rootcatalog}"
        lappend xml.catalog_list [subst {${xml.rootcatalog} ${catalog}}]
    }
}

proc xml._set_catalog_entry {option action args} {
    global xml.catalog_list
    global xml.rootcatalog
    if {$action != "set"} return
    set clist [option ${option}]
    if {[llength ${clist}] >= 2} {
        set c [lindex $clist 0]
        foreach catalog [lrange ${clist} 1 end] {
            ui_debug "add catalog ${catalog} to ${c}"
            lappend xml.catalog_list [subst {${c} ${catalog}}]
        }
    }
}

proc xml._set_entity {option action args} {
    global xml.entity_list
    if {$action != "set"} return
    set entity [option ${option}]
    ui_debug "add entity ${entity}"
    lappend xml.entity_list ${entity}
}

proc xml._set_rewrite {option action args} {
    global xml.rewrite_list
    if {$action != "set"} return
    set rewrite [option ${option}]
    ui_debug "add rewrite ${rewrite}"
    lappend xml.rewrite_list ${rewrite}
}

proc xml._install_catalogs {} {
    global xml.catalog_list xml.entity_list xml.rewrite_list
    global xml.rootcatalog
    foreach catalog ${xml.catalog_list} {
        set c [join [lindex ${catalog} 0]]
        set v [join [lindex ${catalog} 1]]
        if {![file exists ${c}]} {
            ui_debug "create catalog ${c}"
            system "xmlcatmgr -c ${c} create"
        }
        # Add the nextCatalog entry to the catalog if it does not exist
        # xmlcatmgr returns one if the existing entry is not found
        if {[catch {exec xmlcatmgr -c ${c} lookup ${v}}]} {
            ui_debug "add catalog ${v} to ${c}"
            system "xmlcatmgr -c ${c} add nextCatalog '${v}'"
        } else {
            ui_debug "catalog ${v} found in ${c}"
        }
    }
    # Each entity is stored as a list
    foreach entity ${xml.entity_list} {
        set o [join [lindex ${entity} 0]]
        set v [join [lindex ${entity} 1]]
        if {![file exists ${xml.rootcatalog}]} {
            ui_debug "create catalog ${xml.rootcatalog}"
            system "xmlcatmgr -c ${xml.rootcatalog} create"
        }
        # Add the entity to the catalog if it does not exist
        # xmlcatmgr returns one if the existing entry is not found
        ui_debug "check for entity ${entity} (${o} ${v})"
        if {[catch {exec xmlcatmgr -c ${xml.rootcatalog} lookup ${o}}]} {
            ui_debug "add entity public ${o}"
            system "xmlcatmgr -c ${xml.rootcatalog} add public '${o}' '${v}'"
        } else {
            ui_debug "entity ${o} found; not added"
        }
    }
    foreach rewrite ${xml.rewrite_list} {
        set t [join [lindex ${rewrite} 0]]
        set o [join [lindex ${rewrite} 1]]
        set v [join [lindex ${rewrite} 2]]
        if {![file exists ${xml.rootcatalog}]} {
            ui_debug "create catalog ${xml.rootcatalog}"
            system "xmlcatmgr -c ${xml.rootcatalog} create"
        }
        ui_debug "add rewrite ${rewrite} (${t} ${o} ${v})"
        # Add the rewrite entry to the catalog if it does not exist
        # xmlcatmgr returns one if the existing entry is not found
        if {[catch {exec xmlcatmgr -c ${xml.rootcatalog} lookup ${o}}]} {
            system "xmlcatmgr -c ${xml.rootcatalog} add rewrite${t} ${o} ${v}"
        }
    }
}

proc xml._uninstall_catalogs {} {
    global xml.catalog_list xml.entity_list xml.rewrite_list
    global xml.rootcatalog
    foreach catalog ${xml.catalog_list} {
        set c [join [lindex ${catalog} 0]]
        set v [join [lindex ${catalog} 1]]
        # Remove the CATALOG entry from the catalog
        # xmlcatmgr returns zero if the existing entry is found
        if {![catch {exec xmlcatmgr -c ${c} lookup ${v}}]} {
            ui_debug "remove catalog ${v} from ${c}"
            system "xmlcatmgr -c ${c} remove nextCatalog ${v}"
        } else {
            ui_debug "catalog ${v} not found in ${c}"
        }
    }
    foreach entity ${xml.entity_list} {
        set o [join [lindex ${entity} 0]]
        set v [join [lindex ${entity} 1]]
        # Remove the public entry from the catalog
        # xmlcatmgr returns zero if the existing entry is found
        if {![catch {exec xmlcatmgr -c ${xml.rootcatalog} lookup ${o}}]} {
            ui_debug "remove entity ${entity}"
            system "xmlcatmgr -c ${xml.rootcatalog} remove public '${o}'"
        } else {
            ui_debug "entity ${entity} not found for removal"
        }
    }
    foreach rewrite ${xml.rewrite_list} {
        set t [join [lindex ${rewrite} 0]]
        set o [join [lindex ${rewrite} 1]]
        set v [join [lindex ${rewrite} 2]]
        # Remove the rewrite entry from the catalog
        # xmlcatmgr returns zero if the existing entry is found
        if {![catch {exec xmlcatmgr -c ${xml.rootcatalog} lookup ${o}}]} {
            ui_debug "remove rewrite ${rewrite}"
            system "xmlcatmgr -c ${xml.rootcatalog} remove rewrite${t} '${o}'"
        } else {
            ui_debug "rewrite ${rewrite} not found for removal"
        }
    }
}

proc sgml._set_catalog {option action args} {
    global sgml.catalog_list
    global sgml.rootcatalog
    if {$action != "set"} return
    foreach catalog [option ${option}] {
        ui_debug "add catalog ${catalog} to ${sgml.rootcatalog}"
        lappend sgml.catalog_list [subst {${sgml.rootcatalog} ${catalog}}]
    }
}

proc sgml._set_catalog_entry {option action args} {
    global sgml.catalog_list
    global sgml.rootcatalog
    if {$action != "set"} return
    set clist [option ${option}]
    if {[llength ${clist}] >= 2} {
        set c [lindex $clist 0]
        foreach catalog [lrange ${clist} 1 end] {
            ui_debug "add catalog ${catalog} to ${c}"
            lappend sgml.catalog_list [subst {${c} ${catalog}}]
        }
    }
}

proc sgml._install_catalogs {} {
    global sgml.catalog_list
    global sgml.rootcatalog
    foreach catalog ${sgml.catalog_list} {
        set c [join [lindex ${catalog} 0]]
        set v [join [lindex ${catalog} 1]]
        if {![file exists ${c}]} {
            ui_debug "create catalog ${c}"
            system "xmlcatmgr -s -c ${c} create"
        }
        # Add the nextCatalog entry to the catalog if it does not exist
        # xmlcatmgr returns one if the existing entry is not found
        if {[catch {exec xmlcatmgr -s -c ${c} lookup ${v}}]} {
            ui_debug "add catalog ${v} to ${c}"
            system "xmlcatmgr -s -c ${c} add CATALOG '${v}'"
        } else {
            ui_debug "catalog ${v} found in ${c}"
        }
    }
}

proc sgml._uninstall_catalogs {} {
    global sgml.catalog_list
    global sgml.rootcatalog
    foreach catalog ${sgml.catalog_list} {
        set c [join [lindex ${catalog} 0]]
        set v [join [lindex ${catalog} 1]]
        # Remove the CATALOG entry from the catalog
        # xmlcatmgr returns zero if the existing entry is found
        if {![catch {exec xmlcatmgr -s -c ${c} lookup ${v}}]} {
            ui_debug "remove catalog ${v} from ${c}"
            system "xmlcatmgr -s -c ${c} remove CATALOG ${v}"
        } else {
            ui_debug "catalog ${v} not found in ${c}"
        }
    }
}

post-activate {
    global xml.catalog_list xml.entity_list xml.rewrite_list
    global xml.rootcatalog
    global xml.rootdir
    global xml.confdir
    global sgml.confdir
    global sgml.rootcatalog
    # XML catalog
    # Make the directory if it doesn't exist
    if {![file exists ${xml.confdir}]} {
        xinstall -m 755 -d ${xml.confdir}
    }

    # Create the XML catalog file if it doesn't exist
    if {![file exists ${xml.rootcatalog}]} {
        system "xmlcatmgr -c ${xml.rootcatalog} create"
    }

    # SGML catalog
    # Make the directory if it doesn't exist
    if {![file exists ${sgml.confdir}]} {
        xinstall -m 755 -d ${sgml.confdir}
    }

    # Create the SGML catalog file if it doesn't exist
    if {![file exists ${sgml.rootcatalog}]} {
        system "xmlcatmgr -s -c ${sgml.rootcatalog} create"
    }

    xml._install_catalogs
    sgml._install_catalogs
}

pre-deactivate {
    sgml._uninstall_catalogs
    xml._uninstall_catalogs
    # Should not remove the catalogs because if we update this package
    # other dependent packages will not be reinstalled to replace entries
    # they may have inserted in the catalog(s).
    # exec xmlcatmgr -s -c ${sgml.rootcatalog} destroy
    # exec xmlcatmgr -c ${xml.rootcatalog} destroy
}
