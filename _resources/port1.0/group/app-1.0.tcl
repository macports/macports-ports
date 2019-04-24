# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup helps create an application bundle the user can open from the
# Finder or the Dock. This is useful for ports that install a program built
# with an SDK like SDL or Qt that, when launched, causes an icon to appear in
# the Dock and opens a proper macOS GUI, but that do not build their own
# app bundle to easily launch it.


# app.create: whether to create the app bundle at all
#
# The default is yes.

options app.create
default app.create yes


# app.name: the name of the app that users will see in the Finder
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


# app.executable: the program the app will run
#
# The default is ${name}; relative paths are relative to ${prefix}/bin. If you
# specify a relative or absolute path to a program that exists in ${destroot},
# the app will contain a symlink to that program. If you specify an absolute
# path in ${workpath} or ${filespath} it will be copied into the app. This is
# useful if you need to write a wrapper script, for example to set environment
# variables. If your wrapper script can be used as-is, leave it in ${filespath}
# and let it be copied from there. If the wrapper needs placeholders to be
# reinplaced first, copy it into ${workpath}, do your reinplacing, then let it
# be copied from there.
#
# Relates to Info.plist key CFBundleExecutable.

options app.executable
default app.executable {${name}}


# app.icon: the icon the app will have
#
# The default is empty; if no icon graphic is available for this software, this
# is fine. You can supply the path to an existing .icns file, or the path to a
# .png or other graphic file that the makeicns program can convert. A build
# dependency on makeicns will be added automatically if needed. You can also
# supply the path to a .svg file and it will be rasterized to the different icon
# formats. A build dependency on librsvg will be added automatically if needed.
# Paths may be absolute or relative to ${worksrcpath}.
#
# Relates to Info.plist key CFBundleIconFile.

options app.icon
default app.icon ""


# app.short_version_string: the version number
#
# The default is ${version}. This is fine for most ports, but ports that list
# both version and build number in ${version} may wish to separate these here.
#
# Info.plist key CFBundleShortVersionString.

options app.short_version_string
default app.short_version_string {${version}}


# app.version: the build number
#
# The default is ${version}. This is fine for most ports, but ports that list
# both version and build number in ${version} may wish to separate these here.
#
# Info.plist key CFBundleVersion.

options app.version
default app.version {${version}}


# app.identifier: the app's unique bundle identifier
#
# The default is computed based on ${homepage} and ${app.name}. For most ports
# this does not need to be overridden, but for software that already has an
# established bundle identifier outside of MacPorts, you can set it here.
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


# app.retina: whether the app supports Retina display resolutions
#
# The default is no.
#
# Info.plist key NSHighResolutionCapable.

options app.retina
default app.retina no


# app.hide_dock_icon: hide the Dock icon
#
# SDKs like SDL and Qt use the necessary macOS APIs to implement proper Dock
# icon functionality, including stopping the icon from bounding when the app
# has finished launching and bringing the app to the front when the icon is
# clicked. Other SDKs like X11 don't use those macOS APIs, so Dock icons for
# apps using those SDKs would not function correctly and should be hidden. The
# default is based on whether the port has an x11 variant and the user has
# enabled it.
#
# Info.plist key LSUIElement.

options app.hide_dock_icon
default app.hide_dock_icon  {[app.get_default_hide_dock_icon]}

proc app.get_default_hide_dock_icon {} {
    return [variant_exists x11] && [variant_isset x11]
}


# app.use_launch_script: use a Bash launch script instead of a symlink to the executable
#
# The default behaviour is to symlink the executable into the bundle. However,
# this has two issues: OS X 10.8 and earlier pass a `-psn` argument (the process
# serial number) to the executable, which some programs can't handle. Also, it
# doesn't modify the PATH, e.g. to add ${prefix}/bin to it. Using a launch
# script solves both of these issues.

options app.use_launch_script
default app.use_launch_script  no


platform macosx {
    pre-destroot {
        if {[tbool app.create]} {
            # Ensure app.name is valid.
            if {[regexp {[/]} ${app.name}]} {
                return -code error "app.name ${app.name} contains illegal characters"
            }

            # Make the app bundle directories.
            xinstall -d ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS \
                        ${destroot}${applications_dir}/${app.name}.app/Contents/Resources
        }
    }

    post-destroot {
        if {[tbool app.create]} {
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
                    xinstall -m 0644 ${icon} ${destroot}${applications_dir}/${app.name}.app/Contents/Resources/${app.name}.icns

                # If app.icon is svg, rasterize and convert it.
                } elseif {[file extension ${icon}] == ".svg"} {
                    set makeicnsargs {}
                    foreach w {16 32 128 256 512} {
                        lappend makeicnsargs -$w ${worksrcpath}/${w}.png

                        if {[catch {system -W ${worksrcpath} "${prefix}/bin/rsvg-convert -w $w -h $w ${icon} > ${worksrcpath}/$w.png" }]} {
                            return -code error "app.icon ${app.icon} could not be converted to png: $::errorInfo"
                        }
                    }
                    if {[catch {system -W ${worksrcpath} "${prefix}/bin/makeicns $makeicnsargs -out ${destroot}${applications_dir}/${app.name}.app/Contents/Resources/${app.name}.icns 2>@1"}]} {
                        return -code error "app.icns could not be created: $::errorInfo"
                    }

                # If app.icon is another type of image file, convert it.
                } else {
                    if {[catch {system -W ${worksrcpath} "${prefix}/bin/makeicns -in ${icon} -out ${destroot}${applications_dir}/${app.name}.app/Contents/Resources/${app.name}.icns 2>@1"}]} {
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

            # If app.executable is in the destroot, use it as the target.
            if {[file exists ${destroot}[app._resolve_symlink ${executable} ${destroot}]]} {
                if {[tbool app.use_launch_script]} then {
                    app._write_launch_script ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}
                } else {
                    ln -s ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}
                }
            } elseif {[file exists ${executable}]} {
                # If app.executable starts with ${workpath} or ${filespath}, copy it.
                if {[string first ${workpath} ${executable}] == 0 || [string first ${filespath} ${executable}] == 0} {
                    xinstall ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}

                # app.executable refers to a file that exists but does not belong to this port.
                # Assume it belongs to a dependency and use it as the target.
                } else {
                    if {[tbool app.use_launch_script]} then {
                        app._write_launch_script ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}
                    } else {
                        ln -s ${executable} ${destroot}${applications_dir}/${app.name}.app/Contents/MacOS/${app.name}
                    }
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
            if {[tbool app.retina]} {
                puts ${fp} "    <key>NSHighResolutionCapable</key>
    <true/>"
            }
            if {[tbool app.hide_dock_icon]} {
                puts ${fp} "    <key>LSUIElement</key>
    <true/>"
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
    set needs_dep [expr {[file extension ${option}] != ".icns"}]
    if {${needs_dep}} {
        depends_build-delete port:makeicns
        depends_build-append port:makeicns
    }
    set needs_dep [expr {[file extension ${option}] == ".svg"}]
    if {${needs_dep}} {
        depends_build-delete port:librsvg
        depends_build-append port:librsvg
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


# Write a launch script for the executable into the bundle, modifying PATH to
# allow the executable to find other executables installed with MacPorts.
proc app._write_launch_script  {executable app_destination} {
    global prefix
    set launch_script [open ${app_destination} w]

    puts ${launch_script} "#!/bin/bash
export PATH=\"${prefix}/bin:${prefix}/sbin:\$PATH\"
exec ${executable}
"
    close ${launch_script}
    file attributes ${app_destination} -permissions 0755
}
