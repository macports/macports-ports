#!/bin/sh 
# This test needs macports to be installed to work
# start as tcl \
exec tclsh "$0" "$@"

set prefix                    [file dirname [file dirname [exec which port]]]
set os.platform               i686-darwin

# mock the commands the ruby group uses
proc name p0                  {
	global name.found
	set name.found $p0
}
proc version p0               {
	global version.found
	set version.found $p0
}
proc categories p0	      {}
proc distname p0	      {}
proc dist_subdir p0	      {}
proc depends_lib p0	      {
	global depends_lib.found
	set depends_lib.found $p0
}
proc post-extract p0	      {}
proc configure.cmd {p0 p1 p2} {}
proc configure.pre_args p0    {}
proc build.target p0	      {
	global build.target.found
	set build.target.found $p0
}
proc build.cmd {p0 p1 p2}     {}
proc pre-destroot p0	      {}
proc destroot.cmd {p0 p1 p2}  {}
proc destroot.target p0	      {}
proc destroot.destdir {}      {}
proc post-destroot p0	      {}

proc use_configure p0	      {}
proc extract.suffix p0	      {}
proc depends_lib-append p0    {}
proc extract p0		      {}
proc build p0		      {}
proc destroot p0	      {}

# directory which contains test file
set testdir [file dirname ${argv0}]

namespace eval tests {
	# Backwards compatible behaviour, assumes ruby1.8
	proc test_rubysetup_ruby18_default {} {
		global prefix
		global ruby.bin
		global ruby.version
		global ruby.module
		global ruby.project
		global ruby.filename 
		global ruby.docs
		global ruby.lib ruby.archlib

		global build.target.found
		global name.found
		global version.found
		global depends_lib.found

		ruby.setup {test_module tmod} 9.9 setup.rb {README INSTALL}

		if {![file exists ${ruby.bin}]} { return }
		if {"1.8" ne ${ruby.version}} { error "ruby.version failed: ${ruby.version}" }
		if {"test_module" ne ${ruby.module}} { error "ruby.module failed" }
		if {"tmod" ne ${ruby.project}} { error "ruby.project failed" }
		if {"tmod" ne ${ruby.filename}} { error "ruby.filename failed" }
		if {{README INSTALL} ne ${ruby.docs}} { error "ruby.docs failed"}
		if {"setup" ne ${build.target.found}} { error "type-derived field build.target failed: ${build.target.found}"}
		if {"rb-test_module" ne ${name.found}} { error "drived name failed: ${name.found}" }
		if {"9.9" ne ${version.found}} { error "port version set failed" }
		if {"port:ruby" ne ${depends_lib.found}} { error "depends_lib failed: ${depends_lib.found}" }

		if {"${prefix}/lib/ruby/vendor_ruby/1.8" ne ${ruby.lib}} { error "ruby.lib failed: ${ruby.lib}" }
		if {!(0 == [string first "${prefix}/lib/ruby/vendor_ruby/1.8/i686-darwin" ${ruby.archlib}])} { error "ruby.archlib failed: ${ruby.archlib}" }
	}

	proc test_rubysetup_type_gem {} {
		if {[catch {ruby.setup {test_module tmod} 9.9 gem {README INSTALL}}]} {
			error "gem type port fails"
		}
	}

	proc test_rubysetup_ruby19 {} {
		global prefix
		global ruby.version
		global ruby.module
		global ruby.project
		global ruby.filename 
		global ruby.bin
		global ruby.docs
		global ruby.lib ruby.archlib

		global build.target.found
		global name.found
		global version.found
		global depends_lib.found

		ruby.setup {test_module tmod} 9.9 setup.rb {README INSTALL} custom ruby19

		# changed prefix
		if {![file exists ${ruby.bin}]} { return }
		if {![string equal "1.9.0" ${ruby.version}]} { error "ruby.version failed: '${ruby.version}'" }
		if {![string equal "rb19-test_module" ${name.found}]} { error "drived name failed: ${name.found}" }

		if {![string equal "test_module" ${ruby.module}]} { error "ruby.module failed" }
		if {![string equal "tmod" ${ruby.project}]} { error "ruby.project failed" }
		if {![string equal "tmod" ${ruby.filename}]} { error "ruby.filename failed" }
		if {![string equal {README INSTALL} ${ruby.docs}]} { error "ruby.docs failed"}
		if {![string equal "setup" ${build.target.found}]} { error "type-derived field failed: ${build.target.found}"}
		if {![string equal "9.9" ${version.found}]} { error "port version set failed" }
		if {![string equal "port:ruby19" ${depends_lib.found}]} { error "depends_lib failed: ${depends_lib.found}" }

		if {![string equal "${prefix}/lib/ruby/vendor_ruby/1.9.0" ${ruby.lib}]} { error "ruby.lib failed: ${ruby.lib}" }
		if {!(0 == [string first "${prefix}/lib/ruby/vendor_ruby/1.9.0/i686-darwin" ${ruby.archlib}])} { error "ruby.archlib failed: ${ruby.archlib}" }
	}

	proc test_setup_implementation_specifics {} {
		if {![catch {ruby.setup {test_module tmod} 9.9 setup.rb {README INSTALL} custom "rubz"}]} {
			error "wrong implementation name signals error"
		}
	}

	proc test_variables_exported_without_rubysetup_call {} {
		global prefix
		global ruby.bin ruby.rdoc ruby.gem
		global ruby.version ruby.arch ruby.lib ruby.archlib
		if {"${prefix}/bin/ruby" ne ${ruby.bin}} { error "variable ruby.bin missing" }
		if {"${prefix}/bin/rdoc" ne ${ruby.rdoc}} { error "variable ruby.rdoc missing" }
		if {"${prefix}/bin/gem" ne ${ruby.gem}} { error "variable ruby.gem missing" }
		if {"1.8" ne ${ruby.version}} { error "variable ruby.version missing" }
		if {"" eq ${ruby.arch}} { error "variable ruby.arch missing" }
		if {"${prefix}/lib/ruby/vendor_ruby/1.8" ne ${ruby.lib}} { error "variable ruby.lib missing" }
		if {"" eq ${ruby.archlib}} { error "variable ruby.archlib missing" }
	}
	
	# run all tests
	if {![file executable $prefix/bin/ruby]} {
		puts "WARNING: No ruby found, can't run ruby port group tests without installed ruby port; skipping."
	} else {
		foreach test [info procs test_*] { 
			# evaluate port group file in global context 
			# to reset global variables
			uplevel {source "${testdir}/../ruby-1.0.tcl"}
			$test
		}
	}
}
