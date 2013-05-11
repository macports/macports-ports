# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2002 Apple Computer, Inc.
# Copyright (c) 2004 Robert Shaw <rshaw@opendarwin.org>
# Copyright (c) 2006-2013 The MacPorts Project
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
# 3. Neither the name of Apple Computer, Inc. nor the names of its
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

# Usage:
#
#   1. use ruby.setup
#
#     PortGroup        ruby 1.0
#     ruby.setup       module version type {} ruby19
#
#   2. use ruby.branch
#
#     PortGroup        ruby 1.0
#     ruby.branch      1.9
#     depends_lib      port:ruby${ruby.suffix}
#     build.cmd        ${ruby.bin}

# options:
#   ruby.branch: select ruby version. 1.8, 1.9 or 2.0.
#   ruby.link_binaries: whether generate suffixed symlink under ${prefix}/bin
#        or not.
# values:
#   ruby.bin, ruby.rdoc, ruby.gem: fullpath to commands for ${ruby.branch}.
#   ruby.suffix: suffix of portname. port:ruby${ruby.suffix} or
#        port:rb${ruby.suffix}-foo.
#   ruby.bindir: install location of commands without suffix from rb-foo.
#   ruby.gemdir: install location of rubygems.
#        such as "${prefix}/lib/ruby1.9/gems/1.9.1".
#   ruby.link_binaries_suffix: suffix of commands from rb-foo under
#        ${prefix}/bin. such as "-1.8" or "-1.9".
#   (obsoleted values)
#   ruby.prog_suffix: use ruby.branch.
#   ruby.version: use ruby.api_version.
# values from ruby.setup:
#   ruby.module: port name without prefix. rb-${ruby.module}.
#   ruby.project: project name at rubygems, rubyforge or sourceforge.

options ruby.default_branch
default ruby.default_branch 1.8
options ruby.branch
options ruby.bin ruby.rdoc ruby.gem ruby.bindir ruby.gemdir ruby.suffix
option_proc ruby.branch ruby_set_branch
proc ruby_set_branch {option action args} {
    if {$action != "set"} {
        return
    }
    global prefix ruby.branch \
           ruby.bin ruby.rdoc ruby.gem ruby.bindir ruby.gemdir \
           ruby.suffix ruby.link_binaries_suffix ruby.api_version \
           ruby.prog_suffix
    set ruby.bin            ${prefix}/bin/ruby${ruby.branch}
    set ruby.rdoc           ${prefix}/bin/rdoc${ruby.branch}
    set ruby.gem            ${prefix}/bin/gem${ruby.branch}
    set ruby.bindir         ${prefix}/libexec/ruby${ruby.branch}
    set ruby.gemdir         ${prefix}/lib/ruby${ruby.branch}/gems/${ruby.api_version}
    # gem command for 1.8 from port:rb-rubygems
    if {${ruby.branch} eq "1.8"} {
        set ruby.gem        ${ruby.bindir}/gem
        set ruby.gemdir     ${prefix}/lib/ruby/gems/${ruby.api_version}
    }
    set ruby.suffix         [join [split ${ruby.branch} .] {}]
    if {${ruby.branch} eq "1.8"} {
        set ruby.suffix     ""
    }
    set ruby.link_binaries_suffix -${ruby.branch}
    set ruby.prog_suffix    ${ruby.branch}
    if {${ruby.branch} eq "1.8"} {
        set ruby.prog_suffix     ""
    }
}

proc ruby.extract_config {var {default ""}} {
    global ruby.bin
    if {[catch {set val [exec ${ruby.bin} -e "require 'rbconfig';puts RbConfig::CONFIG\[\"${var}\"\]"]}]} {
        set val ${default}
    }
    return $val
}

options ruby.api_version ruby.lib ruby.archlib
default ruby.api_version    {[ruby.extract_config ruby_version]}
default ruby.arch           {[ruby.extract_config arch "${os.arch}-${os.platform}${os.major}"]}
# define installation libraries as vendor location
default ruby.lib            {[ruby.extract_config vendorlibdir ${prefix}/lib/ruby/vendor_ruby/${ruby.api_version}]}
default ruby.archlib        {[ruby.extract_config vendorarchdir ${ruby.lib}/${ruby.arch}]}
# ruby.version is obsoleted. use ruby.api_version.
options ruby.version
default ruby.version        {[ruby.extract_config ruby_version]}

set ruby.module         ""
set ruby.filename       ""
set ruby.project        ""
set ruby.docs           {}
set ruby.srcdir         ""

options ruby.link_binaries
default ruby.link_binaries yes

default ruby.branch         ${ruby.default_branch}

# ruby group setup procedure; optional for ruby 1.8 if you want only
# basic variables, like ruby.lib and ruby.archlib.
proc ruby.setup {module vers {type "install.rb"} {docs {}} {source "custom"} {implementation "ruby"}} {
    global destroot prefix worksrcpath os.platform
    global ruby.bin ruby.rdoc ruby.gem
    global ruby.api_version ruby.lib ruby.suffix ruby.bindir ruby.gemdir
    global ruby.module ruby.filename ruby.project ruby.docs ruby.srcdir
    global ruby.link_binaries_suffix
    # ruby.version is obsoleted. use ruby.gemdir.
    global ruby.prog_suffix

    if {${implementation} eq "ruby19"} {
        ruby.branch 1.9
    } elseif {${implementation} eq "ruby20"} {
        ruby.branch 2.0
    } elseif {${implementation} eq "ruby"} {
        ruby.branch 1.8
    } else {
        ui_error "ruby.setup: unknown implementation '${implementation}' specified (ruby, ruby19, ruby20 possible)"
        return -code error "ruby.setup failed"
    }

    # define ruby global names and lists
    # check if module is a list or string
    if {[llength ${module}] > 1} {
        # if a list, first item is the module name
        set ruby.module     [lindex ${module} 0]
        # second argument is the project & file name
        set ruby.project    [lindex ${module} 1]
        set ruby.filename   [lindex ${module} 1]
    } else {
        # else, module, project, and file name are the same
        set ruby.module     ${module}
        set ruby.project    ${module}
        set ruby.filename   ${module}
    }
    set ruby.docs   ${docs}

    name            rb${ruby.suffix}-[string tolower ${ruby.module}]
    version         ${vers}
    categories      ruby

    switch -glob ${source} {
        rubyforge:*:* {
            set num [lindex [split ${source} {:}] 1]
            set ruby.project [string tolower [lindex [split ${source} {:}] 2]]
            homepage        http://rubyforge.org/projects/${ruby.project}
            master_sites    http://rubyforge.org/frs/download.php/${num}/
            livecheck.type  regex
            livecheck.url   http://rubyforge.org/projects/${ruby.project}
            livecheck.regex "<strong>${ruby.project}</strong></td><td>(?:REL )?(.*)$"
        }
        rubyforge:* {
            set num [lindex [split ${source} {:}] 1]
            set ruby.project [string tolower ${ruby.project}]
            homepage        http://rubyforge.org/projects/${ruby.project}
            master_sites    http://rubyforge.org/frs/download.php/${num}/
            livecheck.type  regex
            livecheck.url   http://rubyforge.org/projects/${ruby.project}
            livecheck.regex "<strong>${ruby.project}</strong></td><td>(?:REL )?(.*)$"
        }
        rubyforge_gem:* {
            set ruby.project [string tolower [lindex [split ${source} {:}] 1]]
            homepage        http://rubyforge.org/projects/${ruby.project}
            master_sites    http://gems.rubyforge.vm.bytemark.co.uk/gems/ \
                            http://rubyforge.iasi.roedu.net/gems/
            livecheck.type  regex
            livecheck.url   http://rubyforge.org/projects/${ruby.project}
            livecheck.regex "<strong>${ruby.module}</strong></td><td>(?:REL )?(.*)$"
        }
        rubyforge_gem {
            set ruby.project [string tolower ${ruby.project}]
            homepage        http://rubyforge.org/projects/${ruby.project}
            master_sites    http://gems.rubyforge.vm.bytemark.co.uk/gems/ \
                            http://rubyforge.iasi.roedu.net/gems/
            livecheck.type  regex
            livecheck.url   http://rubyforge.org/projects/${ruby.project}
            livecheck.regex "<strong>${ruby.module}</strong></td><td>(?:REL )?(.*)$"
        }
        rubygems {
            homepage        http://www.rubygems.org/gems/${ruby.project}
            master_sites    http://www.rubygems.org/downloads/
            livecheck.type  regex
            livecheck.url   http://www.rubygems.org/gems/${ruby.project}
            livecheck.regex {<h3>(\d|\d[0-9.]*\d)</h3>}
        }
        sourceforge:* {
            set ruby.project [lindex [split ${source} {:}] 1]
            homepage        http://sourceforge.net/projects/${ruby.project}
            master_sites    sourceforge:${ruby.project}
        }
        sourceforge {
            homepage        http://sourceforge.net/projects/${ruby.project}
            master_sites    sourceforge:${ruby.project}
        }
    }

    distname        ${ruby.filename}-${vers}
    dist_subdir     ruby

    depends_lib     port:${implementation}

    post-extract {
        # Create the work directory for gem-based ruby ports.
        file mkdir ${worksrcpath}
        system "find ${worksrcpath} -type d -name CVS | xargs rm -rf"
    }

    switch -glob ${type} {
        basic_install.rb {
            post-patch {
                # create destroot setup file
                set fp [open ${worksrcpath}/destroot.rb w]
                puts $fp "
                    require 'rbconfig'
                    include Config
                    DESTROOT=ENV\['DESTROOT'\] || ''
                    CONFIG.keys.find_all { |d|
                        d.match(/dir\$/) and !d.match(/(src|build|compile)/)
                    }.each {|confdir|
                        CONFIG\[confdir\]=DESTROOT+CONFIG\[confdir\]
                    }
                    \$:.reverse.each { |d| \$:.unshift(DESTROOT+d) }
                "
                close $fp
                # adjust basic install.rb script
                reinplace "s|site_ruby|vendor_ruby|" ${worksrcpath}/install.rb
            }

            use_configure   no

            build           {}

            pre-destroot {
                xinstall -d -m 0755 ${destroot}${ruby.lib}
            }
            destroot.env    DESTROOT=${destroot}
            destroot.cmd    ${ruby.bin} -rvendor-specific -rdestroot install.rb
            destroot.target
            destroot.destdir
            post-destroot {
                foreach file [readdir ${destroot}${prefix}/bin] {
                    move [file join ${destroot}${prefix}/bin $file] ${destroot}${ruby.bindir}
                }
            }
        }
        copy_install:* {
            set ruby.srcdir [lindex [split ${type} {:}] 1]

            use_configure   no

            build           {}

            destroot {
                set root ${worksrcpath}/${ruby.srcdir}
                xinstall -d -m 0755 ${destroot}${ruby.lib}
                fs-traverse file $root {
                    set file [trimroot $root $file]
                    if {$file ne ""} {
                        set filepath [file join $root $file]
                        if {[file isdirectory $filepath]} {
                            xinstall -d -m 0755 ${destroot}${ruby.lib}/${file}
                        } else {
                            xinstall -m 0644 $filepath ${destroot}${ruby.lib}/${file}
                        }
                    }
                }
            }
        }
        install.rb {
            configure.cmd       ${ruby.bin} -rvendor-specific install.rb
            configure.pre_args  config --bin-dir=${destroot}${ruby.bindir}

            build.cmd           ${ruby.bin} -rvendor-specific install.rb
            build.target        setup

            pre-destroot {
                if {[file isfile ${worksrcpath}/config.save]} {
                    reinplace "s|^prefix=${prefix}|prefix=${destroot}${prefix}|g" \
                        ${worksrcpath}/config.save
                }
                if {[file isfile ${worksrcpath}/.config]} {
                    reinplace "s|^prefix=${prefix}|prefix=${destroot}${prefix}|g" \
                        ${worksrcpath}/.config
                }
            }
            destroot.cmd        ${ruby.bin} -rvendor-specific install.rb
            destroot.target     install
            destroot.destdir
        }
        setup.rb {
            configure.cmd       ${ruby.bin} -rvendor-specific setup.rb
            configure.pre_args  config

            build.cmd           ${ruby.bin} -rvendor-specific setup.rb
            build.target        setup

            pre-destroot {
                if {[file isfile ${worksrcpath}/config.save]} {
                    reinplace "s|${prefix}|${destroot}${prefix}|g" \
                        ${worksrcpath}/config.save
                }
                if {[file isfile ${worksrcpath}/.config]} {
                    reinplace "s|${prefix}|${destroot}${prefix}|g" \
                        ${worksrcpath}/.config
                }
            }
            destroot.cmd        ${ruby.bin} -rvendor-specific setup.rb
            destroot.target     install
            destroot.destdir
            post-destroot {
                foreach file [readdir ${destroot}${prefix}/bin] {
                    move [file join ${destroot}${prefix}/bin $file] ${destroot}${ruby.bindir}
                }
            }
        }
        extconf.rb {
            configure.cmd       ${ruby.bin} extconf.rb
            configure.pre_args
            configure.args      --prefix=${prefix} --vendor

            build.args          RUBY="${ruby.bin}"

            destroot.args       RUBY="${ruby.bin}"
            post-destroot {
                foreach file [readdir ${destroot}${prefix}/bin] {
                    move [file join ${destroot}${prefix}/bin $file] ${destroot}${ruby.bindir}
                }
            }
        }
        gnu {
            build.args          RUBY="${ruby.bin} -rvendor-specific"

            pre-destroot {
                if {[file isfile ${worksrcpath}/config.save]} {
                    reinplace "s|${prefix}|${destroot}${prefix}|g" \
                        ${worksrcpath}/config.save
                }
                if {[file isfile ${worksrcpath}/.config]} {
                    reinplace "s|${prefix}|${destroot}${prefix}|g" \
                        ${worksrcpath}/.config
                }
            }
            destroot.args       RUBY="${ruby.bin} -rvendor-specific"
        }
        gem {
            use_configure no
            extract.suffix .gem

            if {${implementation} eq "ruby"} {
                depends_lib-append  port:rb-rubygems
            }

            extract {}
            build {}

            pre-destroot {
                xinstall -d -m 0755 ${destroot}${ruby.gemdir}
            }

            destroot {
                system -W ${worksrcpath} "${ruby.gem} install --local --force --install-dir ${destroot}${ruby.gemdir} ${distpath}/${distname}.gem"

                set binDir ${destroot}${ruby.gemdir}/bin
                if {[file isdirectory $binDir]} {
                    foreach file [readdir $binDir] {
                        file copy [file join $binDir $file] ${destroot}${ruby.bindir}
                    }
                }
            }
        }
        fetch {
            # do nothing but fetch and extract - for strange installers
            build {}
        }
        default {
            ui_error "ruby.setup: unknown setup type '${type}' specified!"
            return -code error "ruby.setup failed"
        }
    }

    if {$type != "gnu"} {
        configure.universal_args-delete  --disable-dependency-tracking
    }

    pre-destroot {
        xinstall -d -m 0755 ${destroot}${ruby.bindir}
    }

    post-destroot {
        if {${ruby.link_binaries}} {
            foreach bin [glob -nocomplain -tails -directory "${destroot}${ruby.bindir}" *] {
                if {[catch {file type "${destroot}${prefix}/bin/${bin}${ruby.link_binaries_suffix}"}]} {
                    ln -s "${ruby.bindir}/${bin}" "${destroot}${prefix}/bin/${bin}${ruby.link_binaries_suffix}"
                }
            }
        }
        # Install documentation files (if specified)
        if {[llength ${ruby.docs}] > 0} {
            set docPath ${prefix}/share/doc/${name}
            xinstall -d -m 0755 ${destroot}${docPath}
            foreach docitem ${ruby.docs} {
                set docitem [file join ${worksrcpath} ${docitem}]
                if {[file isdirectory ${docitem}]} {
                    set subdir [file tail $docitem]
                    xinstall -d -m 0755 ${destroot}${docPath}/${subdir}
                    fs-traverse file $docitem {
                        set file [trimroot $docitem $file]
                        if {$file ne ""} {
                            set filepath [file join $docitem $file]
                            if {[file isdirectory $filepath]} {
                                xinstall -d -m 0755 ${destroot}${docPath}/${subdir}/${file}
                            } else {
                                xinstall -m 0644 $filepath ${destroot}${docPath}/${subdir}/${file}
                            }
                        }
                    }
                } else {
                    xinstall -m 0644 ${docitem} ${destroot}${docPath}
                }
            }
        }
    }
}

proc trimroot {root path} {
    set acc {}
    set skiproot no
    foreach rootf [file split $root] pathf [file split $path] {
        if {$pathf eq ""} {
            # we've hit the end of the path
            break
        } elseif {$skiproot eq "yes" || $rootf eq ""} {
            lappend acc $pathf
        } elseif {$rootf ne $pathf} {
            # diverged from the root
            lappend acc $pathf
            set skiproot yes
        }
    }
    if {[llength $acc] == 0} {
        return ""
    } else {
        return [eval [subst -nobackslashes -nocommands {file join $acc}]]
    }
}
