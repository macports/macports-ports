# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:filetype=tcl:et:sw=4:ts=4:sts=4

# The gradle PortGroup aids in porting Java projects using the Gradle
# build system.  It attempts to circumvent the common ./gradlew idiom by
# instead depending on the appropriate gradle* port.
#
# Usage:
# PortGroup             gradle 1.0
# gradle.major          9

PortGroup                           java 1.0

# ===== Mandatory options =====

# The major version of Gradle to use.  This is generally found in
# gradle/wrapper/gradle-wrapper.properties.
options gradle.major
default gradle.major                {}

# ===== Optional options =====

# The initialisation scripts to run for the configure phase (if any).
# Paths are relative to ${configure.dir}.
options gradle.init_scripts
default gradle.init_scripts         {}

# The tasks to run for the build phase.
options gradle.build_tasks
default gradle.build_tasks          assemble

# The tasks to run for the test phase (if test.run is enabled).
options gradle.test_tasks
default gradle.test_tasks           test

# Whether to allow Gradle to automatically download any required JDKs
# that are not installed on the system.  This is typically enabled when
# the build requires multiple JDKs, as the java PortGroup cannot yet
# handle depending on multiple Java versions.
options gradle.download_jdks
default gradle.download_jdks        no

# The location of the Gradle User Home directory.  Do not change unless
# you know what you're doing.
options gradle.user_home
default gradle.user_home            {${workpath}/.home/.gradle}

# ===== Standard options =====

# Clear standard configuration flags (i.e. --prefix).
default configure.pre_args          {}

# ===== PortGroup logic =====

namespace eval gradle {}

# Returns the list of arguments common to all Gradle invocations.
proc gradle::common_args {} {
    global                          use_parallel_build \
                                    build.jobs \
                                    gradle.download_jdks \
                                    gradle.user_home

    lappend args                    --no-build-cache \
                                    --no-daemon \
                                    --gradle-user-home=${gradle.user_home} \
                                    --system-prop=pts.enabled=false

    if {${use_parallel_build}} {
        lappend args                --max-workers=${build.jobs} \
                                    --parallel
    } else {
        lappend args                --no-parallel
    }

    if {${gradle.download_jdks}} {
        lappend args               --project-prop=org.gradle.java.installations.auto-download=true
    } else {
        lappend args               --project-prop=org.gradle.java.installations.auto-download=false
    }

    return ${args}
}

# Returns the absolute path of the Gradle program.
proc gradle::prog {} {
    global                          prefix
    return ${prefix}/bin/[gradle::port]
}

# Returns the port providing the desired Gradle program.
proc gradle::port {} {
    global                          gradle.major

    if {${gradle.major} eq ""} {
        return -code error "No specified major version for Gradle"
    }
    if {${gradle.major} eq "9"} {
        return gradle
    }
    return gradle${gradle.major}
}

proc gradle::setup {} {
    global                          gradle.build_tasks \
                                    gradle.init_scripts \
                                    gradle.test_tasks

    depends_build-append            port:[gradle::port]

    if {[llength ${gradle.init_scripts}]} {
        configure.cmd               [gradle::prog]
        configure.pre_args-append   {*}[gradle::common_args]
    } else {
        use_configure               no
    }

    foreach script ${gradle.init_scripts} {
        configure.pre_args-append   --init-script=${script}
    }

    build.cmd                       [gradle::prog]
    build.target                    {*}${gradle.build_tasks}
    build.pre_args-append           {*}[gradle::common_args]

    if {"assemble" in ${gradle.build_tasks}} {
        build.pre_args-append       --exclude-task=javadocJar \
                                    --exclude-task=sourcesJar
    }

    foreach task ${gradle.test_tasks} {
        build.pre_args-append       --exclude-task=${task}
    }

    test.cmd                        [gradle::prog]
    test.target                     {*}${gradle.test_tasks}
    test.pre_args-append            {*}[gradle::common_args]
}

port::register_callback gradle::setup
