# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# If you need to change the version of python that waf uses, override this.
options waf.python_branch
default waf.python_branch   2.7

# You should not need to override this but you can use it if you need to
# declare dependencies on python modules.
options waf.python_version
default waf.python_version  {[string map {. {}} ${waf.python_branch}]}

# You should not need to override this but you can use it if you need to
# run the same python executable that waf uses.
options waf.python
default waf.python {${prefix}/bin/python${waf.python_branch}}

default configure.cmd   {${waf.python} ./waf configure}
configure.post_args-append  --nocache

configure.universal_args-delete --disable-dependency-tracking

default build.cmd       {${waf.python} ./waf}
build.target            build
build.post_args-append  --verbose

destroot.destdir        --destdir=${destroot}

port::register_callback waf::add_dependencies

namespace eval waf {}

proc waf::add_dependencies {} {
    depends_build-append \
                        port:python[option waf.python_version]
}
