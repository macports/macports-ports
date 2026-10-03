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
#   maven.skip_tests   - Skip unit tests (default: yes)
#   maven.goal         - Maven goal to run (default: package)
#   maven.gradle_home  - Directory used as GRADLE_USER_HOME
#                        Useful for Maven projects that internally invoke Gradle
#                        (default: ${workpath}/.home/.gradle)
#   maven.local_repo   - Directory used as the local Maven repository
#                        (default: ${workpath}/.home/.m2/repository)
#
# Notes:
#   - This PortGroup overrides build.target from other PortGroups (e.g. github)
#   - All variable expansions are delayed until build time
#   - The java.version option is included from the java PortGroup

PortGroup java 1.0

depends_build-append bin:mvn3:maven3

use_configure no

# Options
options maven.skip_tests maven.goal maven.gradle_home maven.local_repo
default maven.skip_tests yes
default maven.goal package
default maven.gradle_home {${workpath}/.home/.gradle}
default maven.local_repo {${workpath}/.home/.m2/repository}

pre-build {
    # Gradle user home and local Maven repository
    file mkdir ${maven.gradle_home} ${maven.local_repo}

    # Set build target
    build.target-append ${maven.goal}

    # Gradle cache (configurable per port)
    build.env-append GRADLE_USER_HOME=${maven.gradle_home}

    # Always set local Maven repo
    build.pre_args-append \
        -Dmaven.repo.local=${maven.local_repo}

    # Skip tests. Default: yes (tests are skipped unless overridden).
    if {${maven.skip_tests}} {
        build.pre_args-append -DskipTests
    }
}

# Maven executable
build.cmd mvn3

# Override any inherited build.target (e.g. from github PG)
build.target
