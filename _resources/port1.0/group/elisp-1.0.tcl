# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2013 Dan R. K. Ports <dports@macports.org>
# Copyright (c) 2013 The MacPorts Project
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
