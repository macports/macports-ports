# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup extends lurocks PG for lurocks rocks
#
# Usage:
#
# PortGroup luarocks_org 1.0
#
# see below for a list of options

PortGroup                                       luarocks 1.1

# rock file
# see https://github.com/luarocks/luarocks/wiki/Types-of-rocks
options luarocks.rock
default luarocks.rock                           {}

# name of the uploader of the rock to luarocks.org
options luarocks.uploader
default luarocks.uploader                       {}

# homepage of the rock on luarocks.org
options luarocks.homepage
default luarocks.homepage                       {https://luarocks.org/modules/${luarocks.uploader}/${luarocks.module}}

# location of the module after the rock is unzipped
# a rock consists of a rockspec file and module code
options luarocks.worksrcdir
default luarocks.worksrcdir                     {${luarocks.module}}

# set defaults appropriate for rocks downloaded from luarocks.org

default luarocks.rockspec                       {${extract.dir}/${luarocks.module}-${luarocks.version}/${luarocks.module}-${luarocks.version}.rockspec}
default luarocks.module                         {[join [lrange [split ${luarocks.rock} -] 0 end-2] -]}
default luarocks.version                        {[join [lrange [split [join [lrange [split ${luarocks.rock} -] end-1 end] -] .] 0 end-2] .]}
default luarocks.pure_lua                       {[expr {[string match "*.all.rock" [option luarocks.rock]] ? yes : no}]}

default master_sites                            {https://luarocks.org:luarocks}

default distname                                {[join [lrange [split ${luarocks.rock} .] 0 end-2] .]}
default extract.suffix                          {[join [lrange [split ${luarocks.rock} .] end-1 end] .]}
default distfiles                               {${luarocks.rock}:luarocks}

default extract.cmd                             {${prefix}/bin/luarocks}
default extract.pre_args                        {unpack}
default extract.post_args                       {}

default worksrcdir                              {${luarocks.module}-${luarocks.version}/${luarocks.worksrcdir}}

default livecheck.type                          {regex}
default livecheck.url                           {${luarocks.homepage}}
default livecheck.regex                         {${luarocks.module}/(\[\\\\d.-\]*)}
default livecheck.version                       {${luarocks.version}}

# for compatibility with previous version lua PortGroup
default dist_subdir                             {luarocks}

####################################################################################################################################
# internal procedures
####################################################################################################################################

namespace eval                                  luarocks_org {}

proc luarocks_org::callback {} {
    default homepage                            [option luarocks.homepage]
}
port::register_callback luarocks_org::callback
