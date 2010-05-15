# $Id$
# 
# Copyright (c) 2009 The MacPorts Project
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
# This PortGroup lets a port check that the user's Xcode is sufficiently new.
# 
# Usage:
# 
#   PortGroup               xcodeversion 1.0
#   minimum_xcodeversions   {darwin_major minimum_xcodeversion}
# 
# where darwin_major is the major version of the underlying Darwin OS (e.g. 9
# for Mac OS X 10.5 Leopard) and minimum_xcodeversion is the minimum version
# of Xcode the port requires (e.g. 3.1).

options minimum_xcodeversions
default minimum_xcodeversions {}

pre-extract {
    if {"darwin" == ${os.platform}} {
        set current_xcodeversion [exec defaults read ${developer_dir}/Applications/Xcode.app/Contents/Info CFBundleShortVersionString]
        foreach {darwin_major minimum_xcodeversion} [join ${minimum_xcodeversions}] {
            if {${darwin_major} == ${os.major}} {
                if {[rpm-vercomp ${current_xcodeversion} ${minimum_xcodeversion}] < 0} {
                    ui_msg "On Mac OS X ${macosx_version}, ${name} ${version} requires Xcode ${minimum_xcodeversion} or later but you have Xcode ${current_xcodeversion}."
                    return -code error "incompatible Xcode version"
                }
            }
        }
    }
}
