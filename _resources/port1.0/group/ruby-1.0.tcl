# $Id$
# ruby-1.0.tcl
# 
# Group file for 'ruby' group.
#
# Copyright (c) 2004 Robert Shaw <rshaw@opendarwin.org>
# Copyright (c) 2002 Apple Computer, Inc.
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

# Define these variables assuming ruby1.8 to make them accessible in
# the portfile after port group declaration. They can be modified by
# ruby.setup, e.g. to use another ruby than 1.8.
set ruby.bin	        ${prefix}/bin/ruby
set ruby.rdoc	        ${prefix}/bin/rdoc
set ruby.gem            ${prefix}/bin/gem

proc ruby.extract_config {var {default ""}} {
	global ruby.bin
	if {[catch {set val [exec ${ruby.bin} -e "require 'rbconfig';puts Config::CONFIG\[\"${var}\"\]"]}]} {
		set val ${default}
	}
	return $val
}

options ruby.version ruby.arch ruby.lib ruby.archlib
default ruby.version	{[ruby.extract_config ruby_version]}
default ruby.arch		{[ruby.extract_config arch "${os.arch}-${os.platform}${os.major}"]}
# define installation libraries as vendor location
default ruby.lib		{[ruby.extract_config vendorlibdir ${prefix}/lib/ruby/vendor_ruby/${ruby.version}]}
default ruby.archlib	{[ruby.extract_config vendorarchdir ${ruby.lib}/${ruby.arch}]}

set ruby.module		""
set ruby.filename	""
set ruby.project	""
set ruby.docs		{}
set ruby.srcdir		""

# ruby group setup procedure; optional for ruby 1.8 if you want only
# basic variables, like ruby.lib and ruby.archlib.
proc ruby.setup {module vers {type "install.rb"} {docs {}} {source "custom"} {implementation "ruby"}} {
	global destroot prefix worksrcpath os.platform
	global ruby.bin ruby.rdoc ruby.gem
	global ruby.version ruby.lib
	global ruby.module ruby.filename ruby.project ruby.docs ruby.srcdir

	if {${implementation} eq "ruby19"} {
		set ruby.bin	${prefix}/bin/ruby1.9
		set ruby.rdoc	${prefix}/bin/rdoc1.9
		set ruby.gem    ${prefix}/bin/gem1.9
		set ruby.port_prefix rb19
	} elseif {${implementation} eq "ruby"} {
		# ruby.bin, ruby.rdoc, and ruby.gem set to 1.8 by default
		set ruby.port_prefix rb
	} else {
		ui_error "ruby.setup: unknown implementation '${implementation}' specified (ruby, ruby19 possible)"
		return -code error "ruby.setup failed"
	}

	# define ruby global names and lists
	# check if module is a list or string
	if {[llength ${module}] > 1} {
		# if a list, first item is the module name
		set ruby.module		[lindex ${module} 0]
		# second argument is the project & file name
		set ruby.project	[lindex ${module} 1]
		set ruby.filename	[lindex ${module} 1]
	} else {
		# else, module, project, and file name are the same
		set ruby.module		${module}
		set ruby.project	${module}
		set ruby.filename	${module}
	}
	set ruby.docs	${docs}

	name			${ruby.port_prefix}-[string tolower ${ruby.module}]
	version			${vers}
	categories		ruby

	switch -glob ${source} {
		rubyforge:*:* {
			set num [lindex [split ${source} {:}] 1]
			set ruby.project [string tolower [lindex [split ${source} {:}] 2]]
			homepage		http://rubyforge.org/projects/${ruby.project}
			master_sites	http://rubyforge.org/frs/download.php/${num}/
			livecheck.type	regex
			livecheck.url	http://rubyforge.org/projects/${ruby.project}
			livecheck.regex	"<strong>${ruby.project}</strong></td><td>(?:REL )?(.*)$"
		}
		rubyforge:* {
			set num [lindex [split ${source} {:}] 1]
			homepage		http://rubyforge.org/projects/${ruby.project}
			master_sites	http://rubyforge.org/frs/download.php/${num}/
			livecheck.type	regex
			livecheck.url	http://rubyforge.org/projects/${ruby.project}
			livecheck.regex	"<strong>${ruby.project}</strong></td><td>(?:REL )?(.*)$"
		}
		rubyforge_gem:* {
			set ruby.project [lindex [split ${source} {:}] 1]
			homepage		http://rubyforge.org/projects/${ruby.project}
			master_sites	http://gems.rubyforge.vm.bytemark.co.uk/gems/ \
			                http://rubyforge.iasi.roedu.net/gems/ \
			                http://rubyforge-gems.ruby-forum.com/gems/ \
			                http://ruby.inoack.com/gems/
			livecheck.type	regex
			livecheck.url	http://rubyforge.org/projects/${ruby.project}
			livecheck.regex	"<strong>${ruby.module}</strong></td><td>(?:REL )?(.*)$"
		}
		rubyforge_gem {
			homepage		http://rubyforge.org/projects/${ruby.project}
			master_sites	http://gems.rubyforge.vm.bytemark.co.uk/gems/ \
			                http://rubyforge.iasi.roedu.net/gems/ \
			                http://rubyforge-gems.ruby-forum.com/gems/ \
			                http://ruby.inoack.com/gems/
			livecheck.type	regex
			livecheck.url	http://rubyforge.org/projects/${ruby.project}
			livecheck.regex	"<strong>${ruby.module}</strong></td><td>(?:REL )?(.*)$"
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
			homepage		http://sourceforge.net/projects/${ruby.project}
			master_sites	sourceforge:${ruby.project}
		}
		sourceforge {
			homepage		http://sourceforge.net/projects/${ruby.project}
			master_sites	sourceforge:${ruby.project}
		}
	}

	distname		${ruby.filename}-${vers}
	dist_subdir		ruby

	depends_lib		port:${implementation}

	post-extract {
		# Create the work directory for gem-based ruby ports.
		system "mkdir -p ${worksrcpath}"
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

			use_configure	no

			build			{}

			pre-destroot {
				xinstall -d -m 0755 ${destroot}${ruby.lib}
			}
			destroot.env	DESTROOT=${destroot}
			destroot.cmd	${ruby.bin} -rvendor-specific -rdestroot install.rb
			destroot.target
			destroot.destdir
		}
		copy_install:* {
			set ruby.srcdir	[lindex [split ${type} {:}] 1]

			use_configure	no

			build			{}

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
			configure.cmd		${ruby.bin} -rvendor-specific install.rb
			configure.pre_args	config

			build.cmd			${ruby.bin} -rvendor-specific install.rb
			build.target		setup

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
			destroot.cmd		${ruby.bin} -rvendor-specific install.rb
			destroot.target		install
			destroot.destdir
		}
		setup.rb {
			configure.cmd		${ruby.bin} -rvendor-specific setup.rb
			configure.pre_args	config

			build.cmd			${ruby.bin} -rvendor-specific setup.rb
			build.target		setup

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
			destroot.cmd		${ruby.bin} -rvendor-specific setup.rb
			destroot.target		install
			destroot.destdir
		}
		extconf.rb {
			configure.cmd		${ruby.bin} -rvendor-specific extconf.rb
			configure.pre_args
			configure.args		--prefix=${prefix}

			build.args			RUBY="${ruby.bin} -rvendor-specific"

			destroot.args		RUBY="${ruby.bin} -rvendor-specific"
		}
		gnu {
			build.args			RUBY="${ruby.bin} -rvendor-specific"

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
			destroot.args		RUBY="${ruby.bin} -rvendor-specific"
		}
		gem {
			use_configure no
			extract.suffix .gem
			
			depends_lib-append	port:rb-rubygems
			
			extract {}
			build {}
			
			pre-destroot {
				xinstall -d -m 0755 ${destroot}${prefix}/lib/ruby/gems/${ruby.version}
			}
			
			destroot {
			  system "cd ${worksrcpath} && ${ruby.gem} install --local --force --install-dir ${destroot}${prefix}/lib/ruby/gems/${ruby.version} ${distpath}/${distname}"
			
				set binDir ${destroot}${prefix}/lib/ruby/gems/${ruby.version}/bin
				if {[file isdirectory $binDir]} {
					foreach file [readdir $binDir] {
						file copy [file join $binDir $file] ${destroot}${prefix}/bin
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

	post-destroot {
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
