# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# The love portgroup extends the app portgroup.
# Ports can set any desired app portgroup options.
PortGroup app 1.1

# The branch of LÖVE to use: 0.7, 0.8, 0.9, 0.10, 11, etc.
# Ports must set this.
options love.branch
default love.branch {}

# The .love file to extract, either absolute path or relative to ${worksrcpath}.
# Most ports directly download a project's source code and will not use this.
# Ports can use this if a distfile contains a .love file that is to be
# installed. MacPorts will extract it in the extract phase so that its contents
# could be patched or otherwise changed, and will recompress it in the destroot
# phase. If a .love file is available for direct download, instead set distname,
# "use_zip yes", "extract.suffix .love", and "extract.mkdir yes".
options love.extract
default love.extract {}

# The name of the .love file that will be created in the destroot phase.
# Ports should not need to override this.
options love.file
default love.file {${app.name}.love}

# The directory to zip to create the .love file. Must be an absolute path.
# If love.extract is set, this defaults to the directory it's extracted to.
# Otherwise it defaults to ${build.dir}.
# Ports can override this if needed.
options love.dir
default love.dir {[love::get_dir]}

# Items to exclude when creating the .love file. Paths are relative to
# ${love.dir}. Wildcards are supported. These arguments are passed directly to
# zip. Consult the zip(1) manpage section about --exclude.
# Ports should set this to any items that are not needed at runtime, such as
# README, LICENSE, or .gitignore files.
options love.exclude
default love.exclude {}

# The name of the love port for this branch. Also the name of its executable.
# Ports should not need to override this.
options love
default love {love-${love.branch}}

# The absolute path of the love executable for this branch.
# Ports should not need to override this.
options love.exe
default love.exe {${prefix}/bin/${love}}

# Override app portgroup default to use a launch script.
# Ports should not need to override this.
default app.executable {${workpath}/launcher}

# Override app portgroup default to enable Retina display support.
# Ports should not need to override this.
default app.retina {yes}

# LÖVE apps are zipped archives of lua code, not compiled code.
# Ports should not need to override this.
default supported_archs {noarch}

# LÖVE apps don't vary by OS version but are packaged as an .app on macOS.
# Ports should not need to override this.
default platforms {{darwin any}}

# LÖVE apps don't need to be configured or built, just zipped.
# Ports can override this if needed but ports that need to configure or build
# can also add code in post-configure and post-build blocks.
default use_configure {no}

pre-fetch {
    if {${love.branch} eq {}} {
        ui_error "love.branch is not set"
        return -code error "Portfile needs to set love.branch"
    }
}

post-extract {
    if {${love.extract} ne {}} {
        set zip [love::abspath ${love.extract}]
        set dir [file rootname ${zip}]
        file mkdir ${dir}
        system "unzip -q [shellescape ${zip}] -d [shellescape ${dir}]"
    }
}

build {
    if {${app.executable} eq "${workpath}/launcher"} {
        set fp [open ${app.executable} w]
        puts ${fp} {#!/bin/sh}
        puts ${fp} {cd "$(dirname "$0")"/../Resources}
        puts ${fp} "exec [shellescape ${love.exe}] [shellescape ${love.file}]"
        close ${fp}
    }
}

destroot {
    set cmd [list zip -9 -r ${destroot}${applications_dir}/${app.name}.app/Contents/Resources/${love.file} .]
    if {${love.exclude} ne {}} {
        lappend cmd {-x} {*}${love.exclude}
    }
    system -W ${love.dir} [join [love::map shellescape ${cmd}]]
}

# Items in the love namespace are internal to this portgroup.
# Ports should not access these items directly.
namespace eval love {}

# Invokes a procedure on each item in a list.
# You'd think this would be in Tcl or MacPorts base already.
# From a comment by WHD on https://wiki.tcl-lang.org/page/apply
proc love::map {prefix list} {
    set result {}
    foreach item ${list} {
        lappend result [{*}${prefix} ${item}]
    }
    return ${result}
}

# If given a path relative to worksrcpath, or an absolute path, returns the
# absolute path.
proc love::abspath {path} {
    if {[string index ${path} 0] ne "/"} {
        return [option worksrcpath]/${path}
    }
    return ${path}
}

# If love.extract is set, returns the directory into which its contents are
# extracted. Otherwise, returns ${build.dir}.
proc love::get_dir {} {
    if {[option love.extract] ne {}} {
        return [file rootname [love::abspath [option love.extract]]]
    }
    return [option build.dir]
}

# Portgroup initialization performed after the portfile has been parsed.
proc love::init {} {
    categories-delete love
    categories-append love

    if {[option love.extract] ne {}} {
        depends_extract-delete bin:unzip:unzip
        depends_extract-append bin:unzip:unzip
    }

    depends_build-delete bin:zip:zip
    depends_build-append bin:zip:zip

    if {[option love.branch] ne {}} {
        depends_lib-append  path:[regsub ^[option prefix]/ [option love.exe] {\1}]:[option love]
    }
}

port::register_callback love::init
