# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#===============================================================================
# app 1.1
#-------------------------------------------------------------------------------
# This PortGroup helps create an application bundle the user can open from the
# Finder or the Dock. This is useful for ports that install a program built
# with an SDK like SDL or Qt that, when launched, causes an icon to appear in
# the Dock and opens a proper macOS GUI, but that do not build their own
# app bundle to easily launch it.
#-------------------------------------------------------------------------------
# NOTE: This new version is essentially identical to the original, except that
# it utilizes the pg callback mechanism. This solves some issues when multiple
# pgs are involved, with few if any downsides.
#===============================================================================

namespace eval app {}


#-------------------------------------------------------------------------------
# app.create: whether to create the app bundle at all
#
# The default is yes.
#-------------------------------------------------------------------------------

options app.create
default app.create yes


#-------------------------------------------------------------------------------
# app.name: the name of the app that users will see in the Finder
#
# The default is based on ${name}: if ${name} contains any uppercase letters,
# ${name} is used, otherwise the first character of ${name} is uppercased.
#
# Info.plist key CFBundleName.
#-------------------------------------------------------------------------------

options app.name
default app.name {[app::get_default_name]}

proc app::get_default_name {} {
    global name
    if {[regexp {[A-Z]} ${name}]} {
        return ${name}
    }
    return [string totitle ${name}]
}


#-------------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------

options app.executable
default app.executable {${name}}


#-------------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------

options app.icon
default app.icon ""


#-------------------------------------------------------------------------------
# app.short_version_string: the version number
#
# The default is ${version}. This is fine for most ports, but ports that list
# both version and build number in ${version} may wish to separate these here.
#
# Info.plist key CFBundleShortVersionString.
#-------------------------------------------------------------------------------

options app.short_version_string
default app.short_version_string {${version}}


#-------------------------------------------------------------------------------
# app.version: the build number
#
# The default is ${version}. This is fine for most ports, but ports that list
# both version and build number in ${version} may wish to separate these here.
#
# Info.plist key CFBundleVersion.
#-------------------------------------------------------------------------------

options app.version
default app.version {${version}}


#-------------------------------------------------------------------------------
# app.identifier: the app's unique bundle identifier
#
# The default is computed based on ${homepage} and ${app.name}. For most ports
# this does not need to be overridden, but for software that already has an
# established bundle identifier outside of MacPorts, you can set it here.
#
# Info.plist key CFBundleIdentifier.
#-------------------------------------------------------------------------------

options app.identifier
default app.identifier {[app::get_default_identifier]}

proc app::get_default_identifier {} {
    global homepage
    set app_name [option app.name]

    set identifier [split [lindex [split ${homepage} "/"] 2] .]
    if {[lindex ${identifier} 0] eq "www"} {
        set identifier [lrange ${identifier} 1 end]
    }
    set identifier [lreverse ${identifier}]
    set identifier [concat ${identifier} [lrange [split ${homepage} "/"] 3 end]]
    if {[lindex ${identifier} end] eq ""} {
        set identifier [lrange ${identifier} 0 end-1]
    }
    lappend identifier [string map {"." ""} ${app_name}]
    return [regsub -all -nocase {[^a-z0-9.-]} [join ${identifier} .] ""]
}


#-------------------------------------------------------------------------------
# app.retina: whether the app supports Retina display resolutions
#
# The default is no.
#
# Info.plist key NSHighResolutionCapable.
#-------------------------------------------------------------------------------

options app.retina
default app.retina no


#-------------------------------------------------------------------------------
# app.dark_mode: whether the app supports dark mode
#
# The default is yes.
#
# Info.plist key NSRequiresAquaSystemAppearance.
#-------------------------------------------------------------------------------

options app.dark_mode
default app.dark_mode yes


#-------------------------------------------------------------------------------
# app.privacy_microphone: whether the app needs microphone access
#
# The default is empty and therefore disabled. To enable write a
# message that tells the user why the app is requesting access to the
# device's microphone.
#
# Info.plist key NSMicrophoneUsageDescription.
#-------------------------------------------------------------------------------

options app.privacy_microphone
default app.privacy_microphone ""


#-------------------------------------------------------------------------------
# app.privacy_camera: whether the app needs camera access
#
# The default is empty and therefore disabled. To enable write a
# message that tells the user why the app is requesting access to the
# device's camera.
#
# Info.plist key NSCameraUsageDescription.
#-------------------------------------------------------------------------------

options app.privacy_camera
default app.privacy_camera ""


#-------------------------------------------------------------------------------
# app.privacy_contacts: whether the app needs contacts access
#
# The default is empty and therefore disabled. To enable write a
# message that tells the user why the app is requesting access to the
# user's contacts.
#
# Info.plist key NSContactsUsageDescription.
#-------------------------------------------------------------------------------

options app.privacy_contacts
default app.privacy_contacts ""


#-------------------------------------------------------------------------------
# app.privacy_calendars: whether the app needs calendars access
#
# The default is empty and therefore disabled. To enable write a
# message that tells the user why the app is requesting access to the
# user's calendar data.
#
# Info.plist key NSCalendarsUsageDescription.
#-------------------------------------------------------------------------------

options app.privacy_calendars
default app.privacy_calendars ""


#-------------------------------------------------------------------------------
# app.privacy_photo: whether the app needs photo access
#
# The default is empty and therefore disabled. To enable write a
# message that tells the user why the app is requesting access to the
# user's photo library.
#
# Info.plist key NSPhotoLibraryUsageDescription.
#-------------------------------------------------------------------------------

options app.privacy_photo
default app.privacy_photo ""


#-------------------------------------------------------------------------------
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
#-------------------------------------------------------------------------------

options app.hide_dock_icon
default app.hide_dock_icon  {[app::get_default_hide_dock_icon]}

proc app::get_default_hide_dock_icon {} {
    return [variant_exists x11] && [variant_isset x11]
}


#-------------------------------------------------------------------------------
# app.use_launch_script: use shell launch script instead of symlink to executable
#
# The default behaviour is to symlink the executable into the bundle. However,
# this has two issues: OS X 10.8 and earlier pass a `-psn` argument (the process
# serial number) to the executable, which some programs can't handle. Also, it
# doesn't modify the PATH, e.g. to add ${prefix}/bin to it. Using a launch
# script solves both of these issues.
#-------------------------------------------------------------------------------

options app.use_launch_script
default app.use_launch_script  no


proc app::pre_destroot {} {
    global destroot applications_dir
    set app_name   [option app.name]
    set app_create [option app.create]

    if {[tbool app_create]} {
        # Ensure app.name is valid.
        if {[regexp {[/]} ${app_name}]} {
            return -code error "app.name ${app_name} contains illegal characters"
        }

        # Make the app bundle directories.
        set app_dir ${destroot}${applications_dir}/${app_name}.app
        xinstall -d ${app_dir}/Contents/MacOS \
                    ${app_dir}/Contents/Resources
    }
}


proc app::post_destroot {} {
    global prefix destroot worksrcpath applications_dir
    set app_create               [option app.create]
    set app_dark_mode            [option app.dark_mode]
    set app_executable           [option app.executable]
    set app_hide_dock_icon       [option app.hide_dock_icon]
    set app_icon                 [option app.icon]
    set app_identifier           [option app.identifier]
    set app_name                 [option app.name]
    set app_privacy_calendars    [option app.privacy_calendars]
    set app_privacy_camera       [option app.privacy_camera]
    set app_privacy_contacts     [option app.privacy_contacts]
    set app_privacy_microphone   [option app.privacy_microphone]
    set app_privacy_photo        [option app.privacy_photo]
    set app_retina               [option app.retina]
    set app_short_version_string [option app.short_version_string]
    set app_use_launch_script    [option app.use_launch_script]
    set app_version              [option app.version]

    set app_dir_base      ${destroot}${applications_dir}/${app_name}.app
    set app_dir_contents  ${app_dir_base}/Contents
    set app_dir_macos     ${app_dir_contents}/MacOS
    set app_dir_res       ${app_dir_contents}/Resources

    if {[tbool app_create]} {
        # Ensure app.identifier is valid.
        if {[regexp -nocase {[^a-z0-9.-]} ${app_identifier}]} {
            return -code error "app.identifier ${app_identifier} contains illegal characters"
        }
        if {[llength [split ${app_identifier} "."]] < 3} {
            return -code error "app.identifier ${app_identifier} does not look like a valid CFBundleIdentifier"
        }

        if {${app_icon} ne ""} {
            # Turn relative app.icon paths into absolute ones.
            set icon [join ${app_icon}]
            if {[string index ${icon} 0] ne "/"} {
                set icon ${worksrcpath}/${icon}
            }

            # Ensure app.icon exists.
            if {![file exists ${icon}]} {
                return -code error "app.icon '[join ${app_icon}]' does not exist"
            }

            # If app.icon is an .icns file, copy it.
            if {[file extension ${icon}] eq ".icns"} {
                xinstall -m 0644 ${icon} ${app_dir_res}/${app_name}.icns

            # If app.icon is svg, rasterize and convert it.
            } elseif {[file extension ${icon}] eq ".svg"} {
                set makeicnsargs {}
                foreach w {16 32 128 256 512} {
                    lappend makeicnsargs -$w ${worksrcpath}/${w}.png

                    if {[catch {system -W ${worksrcpath} "${prefix}/bin/rsvg-convert -w $w -h $w [shellescape ${icon}] > ${worksrcpath}/$w.png" }]} {
                        return -code error "app.icon '[join ${app_icon}]' could not be converted to png: $::errorInfo"
                    }
                }
                if {[catch {system -W ${worksrcpath} "${prefix}/bin/makeicns $makeicnsargs -out [shellescape ${app_dir_res}/${app_name}.icns] 2>&1"}]} {
                    return -code error "app.icns could not be created: $::errorInfo"
                }

            # If app.icon is another type of image file, convert it.
            } else {
                if {[catch {system -W ${worksrcpath} "${prefix}/bin/makeicns -in [shellescape ${icon}] -out [shellescape ${app_dir_res}/${app_name}.icns] 2>&1"}]} {
                    return -code error "app.icon '[join ${app_icon}]' could not be converted to ${app_name}.icns: $::errorInfo"
                }
            }
        }

        # Turn relative app.executable paths into absolute ones.
        set executable ${app_executable}
        if {[string index ${executable} 0] ne "/"} {
            set executable ${prefix}/bin/${executable}
        }

        # Check for a possible maintainer error.
        if {[string first ${destroot} ${executable}] == 0} {
            return -code error "app.executable ${app_executable} should not start with \${destroot}"
        }

        # If app.executable is in the destroot, use it as the target.
        if {[file exists ${destroot}[app::resolve_symlink ${executable} ${destroot}]]} {
            if {[tbool app_use_launch_script]} then {
                app::write_launch_script ${executable} ${app_dir_macos}/${app_name}
            } else {
                ln -s ${executable} ${app_dir_macos}/${app_name}
            }
        } elseif {[file exists ${executable}]} {
            # If app.executable starts with ${workpath} or ${filespath}, copy it.
            if {[string first ${workpath} ${executable}] == 0 || [string first ${filespath} ${executable}] == 0} {
                xinstall ${executable} ${app_dir_macos}/${app_name}

            # app.executable refers to a file that exists but does not belong to this port.
            # Assume it belongs to a dependency and use it as the target.
            } else {
                if {[tbool app_use_launch_script]} then {
                    app::write_launch_script ${executable} ${app_dir_macos}/${app_name}
                } else {
                    ln -s ${executable} ${app_dir_macos}/${app_name}
                }
            }
        } else {
            return -code error "app.executable ${app_executable} does not exist"
        }

        # Build the Info.plist.
        set fp [open ${app_dir_contents}/Info.plist w]
        puts ${fp} "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>
    <key>CFBundleExecutable</key>
    <string>${app_name}</string>"
            if {${app_icon} ne ""} {
                puts ${fp} "    <key>CFBundleIconFile</key>
    <string>${app_name}.icns</string>"
            }
            if {[tbool app_retina]} {
                puts ${fp} "    <key>NSHighResolutionCapable</key>
    <true/>"
            }
            if {![tbool app_dark_mode]} {
                puts ${fp} "    <key>NSRequiresAquaSystemAppearance</key>
    <true/>"
            }
            if {${app_privacy_microphone} ne ""} {
                puts ${fp} "    <key>NSMicrophoneUsageDescription</key>
    <string>${app_privacy_microphone}</string>"
            }
            if {${app_privacy_camera} ne ""} {
                puts ${fp} "    <key>NSCameraUsageDescription</key>
    <string>${app_privacy_camera}</string>"
            }
            if {${app_privacy_contacts} ne ""} {
                puts ${fp} "    <key>NSContactsUsageDescription</key>
    <string>${app_privacy_contacts}</string>"
            }
            if {${app_privacy_calendars} ne ""} {
                puts ${fp} "    <key>NSCalendarsUsageDescription</key>
    <string>${app_privacy_calendars}</string>"
            }
            if {${app_privacy_photo} ne ""} {
                puts ${fp} "    <key>NSPhotoLibraryUsageDescription</key>
    <string>${app_privacy_photo}</string>"
            }
            if {[tbool app_hide_dock_icon]} {
                puts ${fp} "    <key>LSUIElement</key>
    <true/>"
            }
            puts ${fp} "    <key>CFBundleIdentifier</key>
    <string>${app_identifier}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${app_name}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${app_short_version_string}</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>${app_version}</string>
</dict>
</plist>"
        close ${fp}

        # Build the PkgInfo file.
        set fp [open ${app_dir_contents}/PkgInfo w]
        puts -nonewline ${fp} "APPL????"
        close ${fp}
    }
}


proc app::check_app_icon {} {
    global depends_build
    set app_icon [option app.icon]

    set needs_dep [expr {[file extension [join ${app_icon}]] ne ".icns"}]
    if {${needs_dep}} {
        depends_build-delete port:makeicns
        depends_build-append port:makeicns
    }
    set needs_dep [expr {[file extension [join ${app_icon}]] eq ".svg"}]
    if {${needs_dep}} {
        depends_build-delete port:librsvg
        depends_build-append port:librsvg
    }
}


# Recursively resolve a symlink in a destroot.
proc app::resolve_symlink {path destroot} {
    if {[catch {set resolved_path [file join [file dirname ${path}] [file readlink ${destroot}${path}]]}]} {
#        ui_debug "In ${destroot}, ${path} is not a symlink"
        return ${path}
    }
#    ui_debug "In ${destroot}, ${path} is a symlink to ${resolved_path}"
    return [app::resolve_symlink ${resolved_path} ${destroot}]
}


# Write a launch script for the executable into the bundle, modifying PATH to
# allow the executable to find other executables installed with MacPorts.
proc app::write_launch_script {executable app_destination} {
    global prefix
    set launch_script [open ${app_destination} w]

    puts ${launch_script} "#!/bin/bash
export PATH=\"${prefix}/bin:${prefix}/sbin:\$PATH\"
exec [shellescape ${executable}]
"
    close ${launch_script}
    file attributes ${app_destination} -permissions 0755
}


proc app::pg_callback {} {
    app::check_app_icon

    pre-destroot {
        app::pre_destroot
    }

    post-destroot {
        app::post_destroot
    }
}


# callback after port is parsed
port::register_callback app::pg_callback
