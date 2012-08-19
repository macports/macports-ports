# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2011 The MacPorts Project
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
# This PortGroup helps create an application bundle the user can open from the
# Finder or the Dock. This is useful for ports that install a program built
# with an SDK like SDL or Qt that, when launched, causes an icon to appear in
# the Dock and opens a proper Mac OS X GUI, but that do not build their own
# app bundle to easily launch it.


# app.create: whether to create the app bundle at all.
#
# The default is yes.

options app.create
default app.create yes


# app.name: the name of the app that users will see in the Finder.
#
# The default is based on ${name}: if ${name} contains any uppercase letters,
# ${name} is used, otherwise the first character of ${name} is uppercased.
#
# Info.plist key CFBundleName.

options app.name
default app.name {[app.get_default_name]}

proc app.get_default_name {} {
    global name
    if {[regexp {[A-Z]} ${name}]} {
        return ${name}
    }
    return [string totitle ${name}]
}


# app.executable: the program the app will run.
#
# The default is ${name}; relative paths are relative to ${prefix}/bin. If you
# specify a relative or absolute path to a program that exists in ${destroot},
# the app will contain a symlink to that program. If you specify an absolute
# path in ${workpath} or ${filespath} it will be copied into the app. This is
# useful if you need to write a wrapper script, for example to set environment
# variables. If your wrapper script can be used as is, leave it in ${filespath}
# and let it be copied from there. If the wrapper needs placeholders to be
# reinplaced first, copy it into ${workpath}, do your reinplacing, then let it
# be copied from there.
#
# Relates to Info.plist key CFBundleExecutable.

options app.executable
default app.executable {${name}}


# app.icon: the icon the app will have.
#
# The default is empty; if no icon graphic is available for this software, this
# is fine. You can supply the path to an existing .icns file, or the path to a
# .png or other graphic file that the makeicns program can convert. A build
# dependency on makeicns will be automatically added if needed. Paths may
# absolute or relative to ${worksrcpath}.
#
# Relates to Info.plist key CFBundleIconFile.

options app.icon
default app.icon ""


# app.short_version_string: the version number.
#
# The default is ${version}. This is fine for most ports, but ports that list
# both version and build number in ${version} may wish to separate these here.
#
# Info.plist key CFBundleShortVersionString.

options app.short_version_string
default app.short_version_string {${version}}


# app.version: the build number.
#
# The default is ${version}. This is fine for most ports, but ports that list
# both version and build number in ${version} may wish to separate these here.
#
# Info.plist key CFBundleVersion.

options app.version
default app.version {${version}}


# app.identifier: the app's unique bundle identifier.
#
# The default is computed based on ${homepage} and ${app.name}. For almost all
# ports this does not need to be overridden.
#
# Info.plist key CFBundleIdentifier.

options app.identifier
default app.identifier {[app.get_default_identifier]}

proc app.get_default_identifier {} {
    global app.name homepage
    set identifier [split [lindex [split ${homepage} "/"] 2] .]
    if {[lindex ${identifier} 0] == "www"} {
        set identifier [lrange ${identifier} 1 end]
    }
    set identifier [lreverse ${identifier}]
    set identifier [concat ${identifier} [lrange [split ${homepage} "/"] 3 end]]
    if {[lindex ${identifier} end] == ""} {
        set identifier [lrange ${identifier} 0 end-1]
    }
    lappend identifier [string map {"." ""} ${app.name}]
    return [regsub -all -nocase {[^a-z0-9.-]} [join ${identifier} .] ""]
}

# Implement our own lreverse proc, if it doesn't already exist. This will be
# the case on Tiger and Leopard which have Tcl 8.4; lreverse is new in Tcl 8.5.
# Taken from http://wiki.tcl.tk/17188
if {[info commands lreverse] == ""} {
    proc lreverse l {
        set r {}
        set i [llength $l]
        while {[incr i -1]} {lappend r [lindex $l $i]}
        lappend r [lindex $l 0]
    }
}


platform macosx {
    post-destroot {
        if {[tbool app.create]} {
            # Ensure app.name is valid.
            if {[regexp {[/]} ${app.name}]} {
                return -code error "app.name ${app.name} contains illegal characters"
            }

            # Make the app bundle directories.
            xinstall -d ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS \
                        ${destroot}${applications_dir}/${app.name}.app/Contents/Resources

            # Ensure app.identifier is valid.
            if {[regexp -nocase {[^a-z0-9.-]} ${app.identifier}]} {
                return -code error "app.identifier ${app.identifier} contains illegal characters"
            }
            if {[llength [split ${app.identifier} "."]] < 3} {
                return -code error "app.identifier ${app.identifier} does not look like a valid CFBundleIdentifier"
            }

            if {${app.icon} != ""} {
                # Turn relative app.icon paths into absolute ones.
                set icon ${app.icon}
                if {[string index ${icon} 0] != "/"} {
                    set icon ${worksrcpath}/${icon}
                }

                # Ensure app.icon exists.
                if {![file exists ${icon}]} {
                    return -code error "app.icon ${app.icon} does not exist"
                }

                # If app.icon is an .icns file, copy it.
                if {[file extension ${icon}] == ".icns"} {
                    xinstall -m 644 ${icon} ${destroot}${applications_dir}/${app.name}.app/Contents/Resources/${app.name}.icns

                # If app.icon is another type of image file, convert it.
                } else {
                    if {[catch {exec ${prefix}/bin/makeicns -in ${icon} -out ${destroot}${applications_dir}/${app.name}.app/Contents/Resources/${app.name}.icns 2>@1}]} {
                        return -code error "app.icon ${app.icon} could not be converted to ${app.name}.icns: $::errorInfo"
                    }
                }
            }

            # Turn relative app.executable paths into absolute ones.
            set executable ${app.executable}
            if {[string index ${executable} 0] != "/"} {
                set executable ${prefix}/bin/${executable}
            }

            # Check for a possible maintainer error.
            if {[string first ${destroot} ${executable}] == 0} {
                return -code error "app.executable ${app.executable} should not start with \${destroot}"
            }

            # If app.executable is in the destroot, link to it.
            if {[file exists ${destroot}[app._resolve_symlink ${executable} ${destroot}]]} {
                ln -s ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}
            } elseif {[file exists ${executable}]} {
                # If app.executable starts with ${workpath} or ${filespath}, copy it.
                if {[string first ${workpath} ${executable}] == 0 || [string first ${filespath} ${executable}] == 0} {
                    xinstall ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}
                } else {
                    return -code error "app.executable ${app.executable} does not belong to this port"
                }
            } else {
                return -code error "app.executable ${app.executable} does not exist"
            }

            # Build the Info.plist.
            set fp [open ${destroot}${applications_dir}/${app.name}.app/Contents/Info.plist w]
            puts ${fp} "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>
    <key>CFBundleExecutable</key>
    <string>${app.name}</string>"
            if {${app.icon} != ""} {
                puts ${fp} "    <key>CFBundleIconFile</key>
    <string>${app.name}.icns</string>"
            }
            puts ${fp} "    <key>CFBundleIdentifier</key>
    <string>${app.identifier}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${app.name}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${app.short_version_string}</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>${app.version}</string>
</dict>
</plist>"
            close ${fp}

            # Build the PkgInfo file.
            set fp [open ${destroot}${applications_dir}/${app.name}.app/Contents/PkgInfo w]
            puts -nonewline ${fp} "APPL????"
            close ${fp}
        }
    }
}


# Trace writes to app.icon and add or remove makeicns dependency as necessary.
trace variable app.icon w app._icon_trace

proc app._icon_trace {optionName unusedIndex unusedOperation} {
    global depends_build
    upvar ${optionName} option
    set has_dep [expr {[info exists depends_build] ? [lsearch ${depends_build} port:makeicns] != -1 : 0}]
    set needs_dep [expr {[file extension ${option}] != ".icns"}]
    if {${has_dep} && !${needs_dep}} {
        depends_build-delete port:makeicns
    } elseif {${needs_dep} && !${has_dep}} {
        depends_build-append port:makeicns
    }
}


# Recursively resolve a symlink in a destroot.
proc app._resolve_symlink {path destroot} {
    if {[catch {set resolved_path [file join [file dirname ${path}] [file readlink ${destroot}${path}]]}]} {
#        ui_debug "In ${destroot}, ${path} is not a symlink"
        return ${path}
    }
#    ui_debug "In ${destroot}, ${path} is a symlink to ${resolved_path}"
    return [app._resolve_symlink ${resolved_path} ${destroot}]
}
