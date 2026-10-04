# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
# vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# PortGroup: maven 1.0
#
# Provides support for building Java projects using Apache Maven.
#
# Usage:
#   PortGroup maven 1.0
#
# Options:
#   java.version       - Required Java version (e.g. 1.8+, 11+, 17+)
#   maven.skip_tests   - Skip unit tests (default: yes)
#   maven.goal         - Maven goal to run (default: package)
#   maven.gradle_home  - Directory (relative to worksrcpath) used as GRADLE_USER_HOME
#                        Useful for Maven projects that internally invoke Gradle
#                        (default: .gradle)
#
# Notes:
#   - This PortGroup overrides build.target from other PortGroups (e.g. github)
#   - All variable expansions are delayed until build time
#   - A local Maven repository is created inside worksrcpath

PortGroup java 1.0

depends_build-append bin:mvn3:maven3

use_configure no

# Options
options maven.skip_tests java.version maven.goal maven.gradle_home
default maven.skip_tests yes
default java.version {}
default maven.goal package
default maven.gradle_home {.gradle}

pre-build {
    # Local Maven repository
    file mkdir ${worksrcpath}/.m2/repository

    # Gradle cache (configurable per port)
    build.env-append GRADLE_USER_HOME=${worksrcpath}/${maven.gradle_home}

    # Always set local Maven repo
    build.pre_args-append \
        -Dmaven.repo.local=${worksrcpath}/.m2/repository

    # Skip tests. Default: yes (tests are skipped unless overridden).
    if {${maven.skip_tests}} {
        build.pre_args-append -DskipTests
    }
}

# Maven executable
build.cmd mvn3

# Override any inherited build.target (e.g. from github PG)
build.target
build.target ${maven.goal}
