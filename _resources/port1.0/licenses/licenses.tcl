# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:filetype=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2007 - 2016 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of The MacPorts Project nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

#==============================================================================
# OSS license data, extracted from macports-infrastructure script
# 'jobs/distributable_lib.tcl'.
#
# To use, simply source from TCL. Note that this script purposely doesn't
# declare/use any namespaces, allowing the dependent script to source it into
# the namespace of its choosing.
#==============================================================================

# Notes:
# 'Restrictive/Distributable' means a non-free license that nonetheless allows
# distributing binaries.
# 'Restrictive' means a non-free license that does not allow distributing
# binaries, and is thus not in the list.
# 'Permissive' is a catchall for other licenses that allow
# modification and distribution of source and binaries.
# 'Copyleft' means a license that requires source code to be made available,
# and derivative works to be licensed the same as the original.
# 'GPLConflict' should be added if the license conflicts with the GPL (and its
# variants like CeCILL and the AGPL) and is not in the list of licenses known
# to do so below.
# 'Noncommercial' means a license that prohibits commercial use.
set good_licenses [list afl agpl apache apsl artistic autoconf beopen bitstreamvera \
                   boost bsd bsd-old cc-by cc-by-sa cddl cecill cecill-b cecill-c cnri copyleft \
                   cpl curl epl fpll fontconfig freetype gd gfdl gpl \
                   gplconflict ibmpl ijg isc jasper lgpl libtool lppl mit \
                   mpl ncsa noncommercial openldap openssl permissive php \
                   psf public-domain qpl restrictive/distributable ruby \
                   sleepycat ssleay tcl/tk vim w3c wtfpl wxwidgets x11 zlib zpl]

foreach lic $good_licenses {
    set license_good($lic) 1
}
unset lic

# keep these values sorted
array set license_conflicts \
    [list \
    afl [list agpl cecill gpl] \
    agpl [list afl apache-1 apache-1.1 apsl beopen bsd-old cc-by-1 cc-by-2 cc-by-2.5 cc-by-3 cc-by-sa cddl cecill cnri cpl epl gd gpl-1 gpl-2 gplconflict ibmpl lppl mpl noncommercial openssl php qpl restrictive/distributable ruby ssleay zpl-1] \
    agpl-1 [list apache freetype gpl-3 gpl-3+ lgpl-3 lgpl-3+] \
    apache [list agpl-1 cecill gpl-1 gpl-2] \
    apache-1 [list agpl gpl] \
    apache-1.1 [list agpl gpl] \
    apsl [list agpl cecill gpl] \
    beopen [list agpl cecill gpl] \
    bsd-old [list agpl cecill gpl] \
    cc-by-1 [list agpl cecill gpl] \
    cc-by-2 [list agpl cecill gpl] \
    cc-by-2.5 [list agpl cecill gpl] \
    cc-by-3 [list agpl cecill gpl] \
    cc-by-sa [list agpl cecill gpl] \
    cddl [list agpl cecill gpl] \
    cecill [list afl agpl apache apsl beopen bsd-old cc-by-1 cc-by-2 cc-by-2.5 cc-by-3 cc-by-sa cddl cnri cpl epl gd gplconflict ibmpl lppl mpl noncommercial openssl php qpl restrictive/distributable ruby ssleay zpl-1] \
    cnri [list agpl cecill gpl] \
    cpl [list agpl cecill gpl] \
    epl [list agpl cecill gpl] \
    freetype [list agpl-1 gpl-2] \
    gd [list agpl cecill gpl] \
    gpl [list afl apache-1 apache-1.1 apsl beopen bsd-old cc-by-1 cc-by-2 cc-by-2.5 cc-by-3 cc-by-sa cddl cnri cpl epl gd gplconflict ibmpl lppl mpl noncommercial openssl php qpl restrictive/distributable ruby ssleay zpl-1] \
    gpl-1 [list agpl apache gpl-3 gpl-3+ lgpl-3 lgpl-3+] \
    gpl-2 [list agpl apache freetype gpl-3 gpl-3+ lgpl-3 lgpl-3+] \
    gpl-3 [list agpl-1 gpl-1 gpl-2] \
    gpl-3+ [list agpl-1 gpl-1 gpl-2] \
    gplconflict [list agpl cecill gpl] \
    ibmpl [list agpl cecill gpl] \
    lgpl-3 [list agpl-1 gpl-1 gpl-2] \
    lgpl-3+ [list agpl-1 gpl-1 gpl-2] \
    lppl [list agpl cecill gpl] \
    mpl [list agpl cecill gpl] \
    noncommercial [list agpl cecill gpl] \
    openssl [list agpl cecill gpl] \
    opensslexception [portlicensecheck::all_licenses_except openssl ssleay] \
    php [list agpl cecill gpl] \
    qpl [list agpl cecill gpl] \
    restrictive/distributable [list agpl cecill gpl] \
    ruby [list agpl cecill gpl] \
    ssleay [list agpl cecill gpl] \
    zpl-1 [list agpl cecill gpl] \
    ]

