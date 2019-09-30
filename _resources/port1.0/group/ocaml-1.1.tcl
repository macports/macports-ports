# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup provides support for building most OCaml projects, and
# will automatically register a build and runtime dependency on port:ocaml.
#
# Usage:
# PortGroup         ocaml 1.1
#
# Common Options:
#
# ocaml.build_type      <oasis|dune|topkg|none>
#   The OCaml build system used by the project. If 'none' (or empty),
#   the standard MacPorts build target will be used.
#
#   The necessarily build dependencies will be registered automatically.
#
#   Default: none (empty)
#
# ocaml.destroot_type   <oasis|dune|topkg|opam|none>
#   The OCaml tool used to perform installation, if it differs from
#   the project's build system. If 'none' (or empty), the standard
#   MacPorts destroot target will be used.
#
#   Any necessarily build dependencies will be registered automatically.
#
#   Default: ${ocaml.build_type}
#
# ocaml.bin             <path>
#   Path to the ocaml(1) binary.
#
#   Default: ${prefix}/bin/ocaml
#
# ocaml.package_dir     <path>
#   Path to the OCaml site-lib directory
#
#   Default: ${prefix}/lib/ocaml/site-lib
#
# ocaml.stublib_dir     <path>
#   Path to the OCaml site-lib stublib directory
#
#   Default: ${ocaml.package_dir}/stublibs
#
# ocaml.use_findlib     <bool>
#   If set to yes, `port:ocamlfind` will be appended
#   to `depends_lib`, and the `OCAMLFIND_DESTDIR` and
#   `OCAMLFIND_LDCONF` environmental variables will be
#   configured appropriately prior to execution of the
#   build and destroot targets.
#
#   This is particularly useful with OCaml projects that
#   use `ocamlfind` in combination with make(1) or
#   another non-OCaml build system.
#
#   Default: Automatically determined based on the value of
#   ${ocaml.build_type}.
#
## Oasis Options
#
# oasis.setup           <path>
#   Path to the Oasis setup.ml file.
#   Default: ${worksrcpath}/setup.ml
#
# oasis.build_docs      <bool>
#   If set to yes, documentation will be built using
#   Oasis' '-doc' step.
#
#   Default: no
#
## Dune Options
#
# dune.root     <path>
#   The dune project root.
#   Default: ${worksrcpath}
#
# dune.packages <string...>
#   If set to a non-empty value, restricts the set of packages
#   visible to dune (using --only-package)
#   Default: The port ${name}, stripped of its initial "ocaml-" prefix (if any)
#
# dune.profile          <string>
#   Build profile.
#   Default: release
#
# dune.build.target     <string>
#   Build target
#   Default: @install
#
## 'topkg' Options
#
# topkg.setup           <path>
#   Path to the topkg pkg.ml file.
#   Default: ${worksrcpath}/pkg/pkg.ml
#

namespace eval ocaml {
    set configs {
        build {
            oasis {
                depends_lib     ocaml-findlib
                depends_build   ocaml-ocamlbuild
                findlib_env     yes
            }
            dune {
                depends_lib     ocaml-findlib
                depends_build   ocaml-dune
            }
            topkg {
                depends_lib     ocaml-findlib
                depends_build   {
                    ocaml-topkg
                    ocaml-ocamlbuild
                }
                findlib_env     yes
            }
            none {
            }
        }

        destroot {
            opam {
                depends_lib     ocaml-findlib
                depends_build   {
                    ocaml-ocamlbuild
                    opam
                }
                findlib_env     yes
            }
            topkg {
                alias_for       opam
            }
        }

        use {
            findlib {
                depends_lib     ocaml-findlib
                findlib_env     yes
            }
            ocamlbuild {
                depends_build   ocaml-ocamlbuild
            }
        }
    }

    proc get_configs {type} {
        return [dict get ${ocaml::configs} ${type}]
    }

    proc resolve_config {type name} {
        set path [list]

        while {true} {
            if {![dict exists [get_configs $type] ${name}]} {
                # If no destroot configuration is found, default to the
                # corresponding build configuration
                if {$type eq "destroot"} {
                    set type "build"
                    continue
                }

                # If not performing alias resolution, just return the original path
                if {[llength $path] == 0} {
                    return [list ${type} ${name}]
                }

                # Report the alias resolution error
                return -code error "No such $type configuration: ${name} (resolved from [join ${path} "->"])"
            }

            # Handle alias resolution
            set cfg [dict get [get_configs $type] ${name}]
            if {[dict exists $cfg alias_for]} {
                set alias_for [dict get $cfg alias_for]

                # Must only contain a single 'alias_for' key
                if {[dict size ${cfg}] != 1} {
                    return -code error "The $type alias for $name contains additional configuration keys"
                }

                # Must not introduce an alias loop
                if {[lsearch $path $alias_for] != -1} {
                    return -code error "The $type alias for $name contains a loop ($alias_for)"
                }

                # Search for the alias target
                lappend path $name
                set name $alias_for
                continue
            }

            return [list ${type} ${name}]
        }
    }

    proc has_config {type name} {
        return [dict exists ${ocaml::configs} {*}[resolve_config $type $name]]
    }

    proc get_config {type name {required no}} {
        if {$required eq "required"} {
            set required yes
        }

        if {![string is bool "$required"]} {
            return -code error "Invalid `required` argument: $required"
        }

        set path [resolve_config $type $name]
        if {[dict exists ${ocaml::configs} {*}${path}]} {
            return [dict get ${ocaml::configs} {*}${path}]
        } elseif {!$required} {
            return -code error "Unknown ocaml $type type: $name"
        } else {
            return [dict create]
        }
    }

    proc get_deps {config dep_type} {
        if {[dict exists $config $dep_type]} {
            return [dict get $config $dep_type]
        } else {
            return {}
        }
    }

    proc get_bool {config default_value args} {
        if {[dict exists $config {*}$args]} {
            return [dict get $config {*}$args]
        } else {
            return $default_value
        }
    }

    proc get_needs_findlib {config} {
        return [get_bool $config no findlib_env]
    }

    proc register_depends {config} {
        global subport

        foreach dt {build lib} {
            set deps [get_deps $config depends_$dt]
            foreach dep ${deps} {
                # Some of our dependencies can use their own ocaml.(build|destroot)_type
                # to bootstrap themselves; make sure we don't register a circular dependency
                # should they do so
                if {${dep} eq ${subport}} {
                    continue
                }

                depends_${dt}-delete port:${dep}
                depends_${dt}-append port:${dep}
            }
        }
    }

    proc register_depends_callback {} {
        global \
            ocaml.build_type \
            ocaml.destroot_type \
            ocaml.use_findlib

        register_depends [get_config build ${ocaml.build_type} required]
        register_depends [get_config destroot ${ocaml.destroot_type} required]

        foreach name {findlib} {
            if {[set ocaml.use_${name}]} {
                register_depends [get_config use ${name}]
            }
        }

        # Everyone gets an OCaml dependency
        depends_lib-delete port:ocaml
        depends_lib-append port:ocaml
    }
}

port::register_callback ocaml::register_depends_callback

# ocaml is not universal
universal_variant no

options ocaml.bin \
        ocaml.build_type \
        ocaml.destroot_type \
        ocaml.package_dir \
        ocaml.stublib_dir \
        ocaml.use_findlib

default ocaml.bin               {${prefix}/bin/ocaml}
default ocaml.package_dir       {${prefix}/lib/ocaml/site-lib}
default ocaml.stublib_dir       {${ocaml.package_dir}/stublibs}
default ocaml.build_type        none
default ocaml.destroot_type     {[ocaml::get_default_destroot_type]}
default ocaml.use_findlib       {[ocaml::get_needs_findlib [ocaml::get_config build ${ocaml.build_type}]]}

option_proc ocaml.build_type    ocaml::set_target_type
option_proc ocaml.destroot_type ocaml::set_target_type

proc ocaml::get_default_destroot_type {} {
    global ocaml.build_type

    # topkg relies on opam to perform installation
    switch -- ${ocaml.build_type} {
        topkg {
            return "opam"
        }
        default {
            return ${ocaml.build_type}
        }
    }
}

proc ocaml::set_target_type {option action args} {
    # We're only interested in mutations
    switch -- $action {
        set     -
        unset   {}
        read    { return }
        default {
            return -code error "Invalid ${option} option_proc action: \"$action\""
        }
    }

    switch -- $option {
        "ocaml.build_type" {
            set type "build"
        }
        "ocaml.destroot_type" {
            set type "destroot"
        }
        default {
            return -code error "Unsupported ${option}"
        }
    }

    # Normalize and validate the (build|destroot) type
    switch -regexp -- $args {
        "^[\s]*$" {
            # Rewrite empty values to "none"
            ${option} none
            return
        }
        default {
            if {![has_config $type ${args}]} {
                return -code error "Invalid value for ${option}: $args"
            }
        }
    }
}


#
# Oasis builds
#
options oasis.setup \
        oasis.build_docs

default oasis.setup         {${worksrcpath}/setup.ml}
default oasis.build_docs    no

commands    oasis.configure \
            oasis.build \
            oasis.build_docs \
            oasis.destroot

default     oasis.configure.cmd         {${ocaml.bin} ${oasis.setup}}
default     oasis.configure.env         {${configure.env}}
default     oasis.configure.dir         {${configure.dir}}
default     oasis.configure.nice        {${configure.nice}}
default     oasis.configure.pre_args    {-configure --prefix ${prefix} --destdir ${destroot}}

default     oasis.build.cmd             {${oasis.configure.cmd}}
default     oasis.build.env             {}
default     oasis.build.dir             {${build.dir}}
default     oasis.build.nice            {${build.nice}}
default     oasis.build.pre_args        {-build}

default     oasis.docs.cmd              {${oasis.build.cmd}}
default     oasis.docs.env              {${oasis.build.env}}
default     oasis.docs.dir              {${oasis.build.dir}}
default     oasis.docs.nice             {${oasis.build.nice}}
default     oasis.docs.pre_args         {-doc}

default     oasis.destroot.cmd          {${oasis.build.cmd}}
default     oasis.destroot.env          {${oasis.build.env}}
default     oasis.destroot.dir          {${destroot.dir}}
default     oasis.destroot.nice         {${destroot.nice}}
default     oasis.destroot.pre_args     {-install}

#
# Dune builds
#
options dune.root \
        dune.packages \
        dune.profile

default dune.root       {${worksrcpath}}
default dune.packages   {[regsub {^(?:ocaml-)?(.*)} ${subport} {\1}]}
default dune.profile    {release}

commands    dune.build \
            dune.destroot

options     dune.build.target

default     dune.build.cmd          {${prefix}/bin/dune}
default     dune.build.env          {}
default     dune.build.dir          {${build.dir}}
default     dune.build.nice         {${build.nice}}
default     dune.build.target       {@install}
default     dune.build.pre_args     {
    build
    -j ${build.jobs}
    --root=${dune.root}
    --profile=${dune.profile}
    --ignore-promoted-rules
    --no-config
    [ocaml::dune_get_only_packages_param]
    --default-target=${dune.build.target}
}
default     dune.build.post_args    {${dune.build.target}}

default     dune.destroot.cmd       {${dune.build.cmd}}
default     dune.destroot.env       {${dune.build.env}}
default     dune.destroot.dir       {${destroot.dir}}
default     dune.destroot.nice      {${destroot.nice}}
default     dune.destroot.pre_args  {
    install
    -j ${build.jobs}
    --root=${dune.root}
    --profile=${dune.profile}
    --ignore-promoted-rules
    --no-config
    --destdir=${destroot}
    ${dune.packages}
}

default     dune.test.cmd           {${dune.build.cmd}}
default     dune.test.env           {${dune.build.env}}
default     dune.test.dir           {${test.dir}}
default     dune.test.nice          {${build.nice}}
default     dune.test.pre_args      {${dune.build.pre_args}}
default     dune.test.post_args     {@runtest}

proc ocaml::dune_get_only_packages_param {} {
    global dune.packages

    if {${dune.packages} eq ""} {
        return ""
    } else {
        return "--only-packages=[join ${dune.packages} ","]"
    }
}

#
# 'topkg' build support
#
options topkg.setup

default topkg.setup                 {${worksrcpath}/pkg/pkg.ml}

commands    topkg.build

default     topkg.build.cmd         {${ocaml.bin} ${topkg.setup}}
default     topkg.build.env         {}
default     topkg.build.dir         {${build.dir}}
default     topkg.build.nice        {${build.nice}}
default     topkg.build.pre_args    {build}

#
# 'opam' destroot support
#
commands    opam.destroot

default     opam.destroot.cmd       {${prefix}/bin/opam-installer}
default     opam.destroot.env       {}
default     opam.destroot.dir       {${destroot.dir}}
default     opam.destroot.nice      {${destroot.nice}}
default     opam.destroot.pre_args  {
    --prefix=${destroot}${prefix}
    --docdir=share/doc
    --libdir=${destroot}${ocaml.package_dir}
    --mandir=share/man
}

#
# Target overrides
#

configure {
    switch ${ocaml.build_type} {
        oasis {
            command_exec oasis.configure
        }
        dune {
        }
        topkg {
        }
        none {
            do-configure
        }
        default {
            return -code error "Unsupported ocaml.build_type: ${ocaml.build_type}"
        }
    }
}

build {
    switch -- ${ocaml.build_type} {
        oasis {
            command_exec oasis.build
            if {[tbool oasis.build_docs]} {
                command_exec oasis.docs
            }
        }
        dune {
            command_exec dune.build
        }
        topkg {
            command_exec topkg.build
        }
        none {
            do-build
        }
    }
}

pre-destroot {
    xinstall -m 0755 -d \
        ${destroot}${ocaml.package_dir} \
        ${destroot}${ocaml.stublib_dir}
}

# Environmental variables required by ocamlfind
proc ocaml::findlib_env {} {
    global destroot ocaml.package_dir

    return [list \
        OCAMLFIND_DESTDIR   "${destroot}/${ocaml.package_dir}" \
        OCAMLFIND_LDCONF    "ignore"
    ]
}

destroot {
    # Save the environment
    global env
    array set saved_env [array get env]

    if {[tbool ocaml.use_findlib]} {
        array set env [ocaml::findlib_env]
    }

    try {
        switch -- ${ocaml.destroot_type} {
            oasis {
                command_exec oasis.destroot
            }
            dune {
                command_exec dune.destroot
            }
            topkg -
            opam {
                command_exec opam.destroot
            }
            none {
                do-destroot
            }
        }
    } finally {
        # Restore the environment.
        array unset env *
        array set env [array get saved_env]
    }
}

test {
    switch -- ${ocaml.build_type} {
        dune {
            command_exec dune.test
        }
        oasis -
        topkg -
        none {
            do-test
        }
    }
}