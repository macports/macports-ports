# $Id$
# 
# Copyright (c) 2010 Dan R. K. Ports <dports@macports.org>
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
# This portgroup contains common definitions for a MacPorts
# installation of TeX Live. It can be used in one of two ways:
#
# 1. for installing "texmf ports". These contain tex files and are
#    installed from preprocessed distfiles made from TeXLive
#    packages. These ports should invoke texlive.texmfport to set up
#    the installation process.
#
# 2. other ports, like texlive-common or texlive-bin can include this
#    portgroup (but not call texlive.texmfport) to get texlive path
#    definitions and the like.

#
# texmf tree paths
#

# texmf files installed by texlive
set texlive_texmfmain "${prefix}/share/texmf-texlive"

# texmf files installed by texlive, but nominally distribution-independent
# not clear it's really necessary to separate these from texmfmain,
# but texlive goes to great effort to keep them separate, so we might as
# well too
set texlive_texmfdist "${prefix}/share/texmf-texlive-dist"

# "local" texmf files, e.g. installed by ports other than texlive
set texlive_texmflocal "${prefix}/share/texmf"

# variable runtime data, e.g. formats
set texlive_texmfsysvar "${prefix}/var/db/texmf"

# configuration data from texconfig
set texlive_texmfsysconfig "${prefix}/etc/texmf"


#
# For installing texmf ports
#

# Files to skip installation of, specified in terms of their path in
# the texmf tree, e.g. texmf-dist/foo/bar/
options texlive.exclude
default texlive.exclude {}

# Skip installing all manpages. A number of texmf ports include
# manpages, but many of them are already installed by texmf-bin.
options texlive.excludemanpages
default texlive.excludemanpages no

options texlive.formats texlive.languages texlive.maps
default texlive.formats {}
default texlive.languages {}
default texlive.maps {}

options texlive.forceupdatecnf
default texlive.forceupdatecnf no

proc texlive.texmfport {} {
    homepage        http://www.tug.org/texlive/
    platforms       darwin
    
    supported_archs noarch 
    
    master_sites    http://flute.csail.mit.edu/texlive/
    use_bzip2       yes

    global name master_sites
    livecheck.type  regex
    livecheck.url   ${master_sites}
    livecheck.regex ${name}-(\\d+)\\.tar\\.bz2

    depends_lib-append port:texlive-common port:texlive-bin

    variant doc description "Install documentation" { }
    variant src description "Install TeX source" { }
    default_variants +doc

    use_configure   no

    build           { }

    destroot {
        set indexlist {"runfiles"}
        if {[variant_isset "doc"]} { lappend indexlist "docfiles" }
        if {[variant_isset "src"]} { lappend indexlist "srcfiles" }

        # copy files listed in tlpkginfo/$indexname into destroot
        foreach indexname $indexlist {            
            set filelist [open ${worksrcpath}/tlpkginfo/${indexname}]
            while {[gets $filelist line] >= 0} {
                if {[lsearch -exact ${texlive.exclude} $line] >= 0} {
                    continue
                }
                set srcfile ${worksrcpath}/${indexname}/$line

                # check for manpages and treat specially
                if [regexp {^texmf/doc/man/man(\d)/([^/]+)} $line -> section filename] {
                    if {![tbool texlive.excludemanpages]} {
                        if [string match "*.$section" $filename] {
                            # actually a manpage; install it
                            copy $srcfile ${destroot}${prefix}/share/man/man$section/
                        } else {
                            # not actually a manpage; do nothing
                            # (e.g. don't install PDF manpages)
                        }
                    }
                } else {
                    # not a manpage; install into requested target dir
                    # translate path in line to destination
                    set splitline [split $line "/"]
                    switch [lindex $splitline 0] {
                        "texmf"      {lset splitline 0 ${texlive_texmfmain}}
                        "texmf-dist" {lset splitline 0 ${texlive_texmfdist}}
                        default { ui_msg "warning: unknown file destination" }
                    }
                    set dstfile [join $splitline "/"]
                    
                    # create directory if necessary, and install file
                    xinstall -d ${destroot}[file dirname $dstfile]
                    copy ${srcfile} ${destroot}${dstfile}
                }
            }
        }

        if {${texlive.formats} != ""} {
            xinstall -d ${destroot}${texlive_texmfsysconfig}/fmtutil.d
            set fmtfilename \
                ${destroot}${texlive_texmfsysconfig}/fmtutil.d/10${name}.cnf
            set fmtfile [open $fmtfilename "w"]
            foreach x ${texlive.formats} {
                set fmtenabled [lindex $x 0]
                set fmtname [lindex $x 1]
                set fmtengine [lindex $x 2]
                set fmtpatterns [lindex $x 3]
                set fmtoptions [lindex $x 4]
                if {!$fmtenabled} {
                    set fmtprefix "#! "
                } else {
                    set fmtprefix ""
                }

                puts $fmtfile \
                    "$fmtprefix$fmtname\t$fmtengine\t$fmtpatterns\t$fmtoptions"

                # Simulate texlinks
                if {($fmtengine != $fmtname) &&
                    ![file exists ${destroot}${prefix}/bin/$fmtname]} {
                    ln -s ${prefix}/bin/$fmtengine \
                        ${destroot}${prefix}/bin/$fmtname
                }
            }
            
            close $fmtfile
        }

        if {${texlive.maps} != ""} {
            xinstall -d ${destroot}${texlive_texmfsysconfig}/updmap.d
            set mapfilename \
                ${destroot}${texlive_texmfsysconfig}/updmap.d/10${name}.cfg
            set mapfile [open $mapfilename "w"]
            foreach x ${texlive.maps} {
                puts $mapfile $x
            }
            close $mapfile
        }

        if {${texlive.languages} != ""} {
            xinstall -d ${destroot}${texlive_texmfsysconfig}/language.d
            set langdatfilename \
                ${destroot}${texlive_texmfsysconfig}/language.d/10${name}.dat
            set langdeffilename \
                ${destroot}${texlive_texmfsysconfig}/language.d/10${name}.def
            set langdatfile [open $langdatfilename "w"]
            set langdeffile [open $langdeffilename "w"]
            foreach x ${texlive.languages} {
                set langname [lindex $x 0]
                set langfile [lindex $x 1]
                set langlhmin [lindex $x 2]
                set langrhmin [lindex $x 3]
                set langsyns [lindex $x 4]

                puts $langdatfile "$langname $langfile"
                foreach syn $langsyns {
                    puts $langdatfile "=$syn"
                }

                foreach syn [concat $langname $langsyns] {
                    ui_msg $syn
                    puts $langdeffile "\\addlanguage{$syn}{$langfile}{}{$langlhmin}{$langrhmin}"
                }
            }
            close $langdatfile
            close $langdeffile
        }
    }

    post-activate {
        system "${prefix}/bin/texhash"
        if {${texlive.forceupdatecnf} || ${texlive.languages} != ""} {
            system "${prefix}/libexec/texlive-update-cnf language.dat"
            system "${prefix}/libexec/texlive-update-cnf language.def"
        }
        if {${texlive.forceupdatecnf} || ${texlive.maps} != ""} {
            system "${prefix}/libexec/texlive-update-cnf updmap.cfg"
            system "${prefix}/bin/updmap-sys"
        }
        if {${texlive.forceupdatecnf} || ${texlive.formats} != ""} {
            system "${prefix}/libexec/texlive-update-cnf fmtutil.cnf"
            system "${prefix}/bin/fmtutil-sys --all"
        }
    }

    post-deactivate {
        # Update ls-R and any config files to reflect that the package
        # is now gone
        system "${prefix}/bin/texhash"
        if {${texlive.forceupdatecnf} || ${texlive.languages} != ""} {
            system "${prefix}/libexec/texlive-update-cnf language.dat"
            system "${prefix}/libexec/texlive-update-cnf language.def"
        }
        if {${texlive.forceupdatecnf} || ${texlive.maps} != ""} {
            system "${prefix}/libexec/texlive-update-cnf updmap.cfg"
        }
        if {${texlive.forceupdatecnf} || ${texlive.formats} != ""} {
            system "${prefix}/libexec/texlive-update-cnf fmtutil.cnf"
        }
        
        # Remove any generated format files
        foreach x ${texlive.formats} {
            set fmtname [lindex $x 1]
            set fmtengine [lindex $x 2]
            switch $fmtengine {
                "mf"       -
                "mf-nowin" {set fmtengine "metafont"}
                "mpost"    {set fmtengine "metapost"}
            }
            
            foreach filename [glob -nocomplain ${texlive_texmfsysvar}/web2c/$fmtengine/$fmtname.*] {
                delete $filename
            }
        }
    }
}
