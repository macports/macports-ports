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
# ${emacs_binary} should also be used for compiling the elisp code,
# but we leave setting that up to the individual portfiles, because
# there's no standard way to do it.
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
