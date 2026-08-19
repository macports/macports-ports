# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:filetype=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup is for ports that require Apple's Metal toolchain
# (metal, metallib) to build.
#
# Using this PortGroup implies the use of Xcode (use_xcode yes) and performs
# a sanity check on the Metal toolchain during pre-configure.
#
# Usage:
# PortGroup           metal 1.0

# Any port which requires the Metal toolchain requires Xcode
use_xcode   yes

pre-configure {
    set xcrun "/usr/bin/xcrun"

    set sdkroot [option configure.sdkroot]
    if {[file isdirectory ${sdkroot}]} {
        set xcrun "env SDKROOT=[shellescape ${sdkroot}] ${xcrun}"
    }

    set metal_check "${xcrun} metal --version"

    if {[catch {system ${metal_check}}]} {
        # The Metal toolchain is not set up correctly, let's see what we can do or recommend

        if {[vercmp ${xcodeversion} 26] >= 0} {
            # The Metal toolchain is an optional component since Xcode 26
            set xcodebuild "/usr/bin/xcodebuild"
            if {[catch {exec ${xcodebuild} -json -showComponent MetalToolchain} metal_toolchain_component_info] \
                    || ![regexp {"status"[[:space:]]*:[[:space:]]*"installed"} ${metal_toolchain_component_info}]} {
                return -code error "Required Metal toolchain component is not installed, \
                    run `${xcodebuild} -downloadComponent MetalToolchain` and try again."
            }
        }

        # The Metal toolchain check could be failing due to a corrupt xcrun cache
        # Let's kill the xcrun cache to see if this fixes the problem
        catch {system "${xcrun} --kill-cache"}

        if {[catch {system ${metal_check}}]} {
            return -code error "Required Metal toolchain not set up properly for use with MacPorts. \
                The toolchain seems to be installed, but `${metal_check}` still fails for the `${macportsuser}` \
                user, even after killing the xcrun cache."
        }
    }
}
