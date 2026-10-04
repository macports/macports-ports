# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup is for ports that install Emacs lisp modules.
#
# The main goal is to allow these ports to support different
# installations of Emacs, e.g. the emacs and emacs-app ports.  The
# assumption here is that all of these emacsen install into the same
# site-lisp directory, ${emacs_lispdir}, and have compatible
# byte-code, so it doesn't matter which one is used to byte-compile
# the lisp code.
#
# Accordingly, the portgroup detects any installed versions of
# emacs/emacs-app/emacs-mac-app, and sets ${emacs_binary} to the
# installed emacs binary, and ${emacs_binary_provider} to the name of
# the port that provides it. If no emacs is installed, it defaults to
# the location and name of the emacs port.
#
# This can be used in the dependency specification, e.g.
#    depends_lib         path:${emacs_binary}:${emacs_binary_provider}
# and ${emacs_binary} can be used for byte-compilation either manually
# or using the optional support below.
#
#
# Optional support for Emacs Lisp module ports
#
# Ports that simply install one or more .el files can opt in to
# default byte-compile and install phases instead of writing their
# own. A port opts in by either:
#   * calling  elpa.setup name version (gnu|nongnu)
#   * setting  elisp.files and/or elisp.source_dir
# for either ELPA or non-ELPA sources, respecfively.
#
# Either of these also marks the port noarch, disables the configure
# phase, and adds a dependency on an Emacs capable of byte-compiling
# the code. Ports that do none of the above are unaffected, and can
# manually add byte-compilation code.
#
# Options:
#   elisp.source_dir    directory containing the .el files
#                       (default: worksrcpath)
#   elisp.files         list of .el files to compile/install
#                       (default: all top-level .el files in
#                        elisp.source_dir)
#   elisp.install_dir   subdirectory of site-lisp to install into
#                       (default: subport name with any .el suffix
#                        removed)
#   elisp.byte_compile  whether to byte-compile (default: yes)
#   elisp.autoloads     whether to generate an autoloads file
#                       (default: yes)
#
# Ports needing custom logic can override the build and/or destroot phases as
# usual, or set elisp.byte_compile / elisp.autoloads to no.
#



set emacs_default_binary             ${prefix}/bin/emacs
set emacs_default_binary_provider    emacs

set emacs_binaries "
    ${prefix}/bin/emacs
    ${applications_dir}/Emacs.app/Contents/MacOS/Emacs
    ${applications_dir}/EmacsMac.app/Contents/MacOS/Emacs
"

set emacs_binary              ${emacs_default_binary}
set emacs_binary_provider     ${emacs_default_binary_provider}
set emacs_binary_found        0

# Find the first matching emacs binary
foreach bin ${emacs_binaries} {
    set provider [registry_file_registered $bin]
    if {[file exists $bin] && $provider != 0} {
        set emacs_binary $bin
        set emacs_binary_provider $provider
        set emacs_binary_found 1
        break
    }
}

set emacs_lispdir            ${prefix}/share/emacs/site-lisp

#
# Optional configuration for elisp module ports
#

options elisp.source_dir
default elisp.source_dir    {${worksrcpath}}

options elisp.files
default elisp.files         {}

options elisp.install_dir
default elisp.install_dir   {[regsub -- {\.el$} ${subport} {}]}

options elisp.byte_compile
default elisp.byte_compile  yes

options elisp.autoloads
default elisp.autoloads     yes

# Filename prefix for the site-start.d snippet that loads this port's
# autoloads. Snippets are loaded in lexical filename order; the value is
# zero-padded so lower numbers load earlier. The default suits ports with no
# ordering requirements.
options elisp.site_start_priority
default elisp.site_start_priority   50

# Internal flag tracking whether a port has opted in to the managed phases.
set elisp_managed           0

#
# elisp.setup: enable noarch settings, an Emacs dependency, and the default
# build/destroot phases. Idempotent, so it is safe to call more than once
# (e.g. via both elpa.setup and an elisp.files declaration).
#

proc elisp.setup {} {
    global elisp_managed emacs_binary emacs_binary_provider

    if {${elisp_managed}} {
        return
    }
    set elisp_managed 1

    supported_archs     noarch
    platforms           any
    use_configure       no

    depends_lib-append  path:${emacs_binary}:${emacs_binary_provider}

    build {
        set srcdir [option elisp.source_dir]
        set files [elisp._get_files]

        if {[option elisp.byte_compile]} {
            foreach el $files {
                ui_info "Byte-compiling ${el}"
                system -W $srcdir \
                    "${emacs_binary} -Q --batch -L . -f batch-byte-compile [shellescape ${el}]"
            }
        }

        if {[option elisp.autoloads] && [llength $files] > 0} {
            set pkg [option elisp.install_dir]
            set autoload_file "${srcdir}/${pkg}-autoloads.el"
            ui_info "Generating autoloads: ${pkg}-autoloads.el"
            system -W $srcdir \
                "${emacs_binary} -Q --batch --eval '(let ((backup-inhibited t)) (if (fboundp (quote loaddefs-generate)) (loaddefs-generate \"[shellescape ${srcdir}]\" \"[shellescape ${autoload_file}]\") (let ((generated-autoload-file \"[shellescape ${autoload_file}]\")) (update-directory-autoloads \"[shellescape ${srcdir}]\"))))'"
        }
    }

    destroot {
        set srcdir [option elisp.source_dir]
        set pkg [option elisp.install_dir]
        set dest ${destroot}${emacs_lispdir}/${pkg}

        xinstall -d ${dest}

        set files [elisp._get_files]
        foreach el $files {
            xinstall -m 0644 ${srcdir}/${el} ${dest}
            # Install corresponding .elc if it exists
            set elc "${srcdir}/[file rootname ${el}].elc"
            if {[file exists $elc]} {
                xinstall -m 0644 $elc ${dest}
            }
        }

        # Install autoloads file if generated, plus a site-start.d snippet so
        # the emacs port's site-start.el loads it at startup (giving real
        # autoloading without the user editing their init file).
        set autoload_file "${srcdir}/${pkg}-autoloads.el"
        if {[option elisp.autoloads] && [file exists $autoload_file]} {
            xinstall -m 0644 $autoload_file ${dest}
            elisp.install_site_start_snippet ${destroot} ${pkg} ${pkg}-autoloads
        }
    }
}

# Helper: install a site-start.d snippet that loads ${loaddefs} (an autoloads
# or loaddefs file, named without the .el suffix) from the port's site-lisp
# subdirectory, so the emacs port's site-start.el loads it at startup. Exposed
# so ports that override the managed destroot (e.g. org-mode) can install a
# snippet themselves.
proc elisp.install_site_start_snippet {destroot pkg loaddefs} {
    global emacs_lispdir
    set ssd ${destroot}${emacs_lispdir}/site-start.d
    xinstall -d ${ssd}
    set prio [format %03d [option elisp.site_start_priority]]
    set snippet ${ssd}/${prio}-${pkg}.el
    set fh [open ${snippet} w]
    puts $fh ";; -*- lexical-binding: t; -*-"
    puts $fh ";; Auto-generated by the elisp 1.0 portgroup for ${pkg}."
    puts $fh "(add-to-list 'load-path \"${emacs_lispdir}/${pkg}\")"
    puts $fh "(load \"${emacs_lispdir}/${pkg}/${loaddefs}\" nil t)"
    close $fh
    file attributes ${snippet} -permissions 0644
}

# Helper: resolve the effective list of .el files.
proc elisp._get_files {} {
    set files [option elisp.files]
    if {$files eq {}} {
        set srcdir [option elisp.source_dir]
        set files [glob -nocomplain -tails -directory $srcdir *.el]
    }
    return $files
}

# Opt in automatically when a port declares its elisp sources.
option_proc elisp.files      elisp._auto_setup
option_proc elisp.source_dir elisp._auto_setup
proc elisp._auto_setup {option action args} {
    if {${action} eq "set" || ${action} eq "append"} {
        elisp.setup
    }
}

#
# elpa.setup: configure master_sites, distname, homepage, and livecheck for a
# package distributed via GNU ELPA or NonGNU ELPA, and opt in to the default
# elisp phases.
#
# Usage: elpa.setup name version (gnu|nongnu)
#        (repository defaults to gnu)
#

proc elpa.setup {elpa_name elpa_version {elpa_repo gnu}} {
    global name

    switch -- ${elpa_repo} {
        gnu {
            set base_url https://elpa.gnu.org/packages
        }
        nongnu {
            set base_url https://elpa.nongnu.org/nongnu
        }
        default {
            return -code error "elpa.setup: unknown repository '${elpa_repo}' (use gnu or nongnu)"
        }
    }

    if {![info exists name] || ${name} eq ""} {
        name            ${elpa_name}
    }
    version             ${elpa_version}
    master_sites        ${base_url}/
    distname            ${elpa_name}-${elpa_version}
    use_tar             yes
    homepage            ${base_url}/${elpa_name}.html

    livecheck.type      regex
    livecheck.url       ${base_url}/${elpa_name}.html
    livecheck.regex     "${elpa_name}-(\\d+(?:\\.\\d+)*)\\.tar"

    elisp.setup
}
