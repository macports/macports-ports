#!/bin/bash
# Copyright (c) 2008 Apple Inc.
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.  IN NO EVENT SHALL THE ABOVE LISTED COPYRIGHT
# HOLDER(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the name(s) of the above
# copyright holders shall not be used in advertising or otherwise to
# promote the sale, use or other dealings in this Software without
# prior written authorization.

X11DIR=/usr/X11
X11FONTDIR=${X11DIR}/lib/X11/fonts

# Are we caching system fonts or user fonts?
system=0

# Are we including OSX font dirs ({/,~/,/System/}Library/Fonts)
osxfonts=1

# Do we want to force a recache?
force=0

# How noisy are we?
verbose=0

# Check if the data in the given directory is newer than its cache
check_dirty() {
    local dir=$1
    local fontfiles=""
    local retval=1

    # If the dir does not exist, we just exit
    if [[ ! -d "${dir}" ]]; then
        return 1
    fi

    # Create a list of all files in the dir
    # Filter out config / cache files.  Ugly... counting down the day until
    # xfs finally goes away
    fontfiles="$(find ${dir}/ -maxdepth 1 -type f | awk '$0 !~ /fonts\..*$|^.*\.dir$/ {print}')"

    # Fonts were deleted (or never there).  Kill off the caches
    if [[ -z "${fontfiles}" ]] ; then
        local f
        for f in "${dir}"/fonts.* "${dir}"/encodings.dir; do
            if [[ -f ${f} ]] ; then
                rm -f "${f}"
            fi
        done
        return 1
    fi

    # Force a recache
    if [[ ${force} == 1 ]] ; then
        retval=0
    fi

    # If we don't have our caches, we are dirty
    if [[ ! -f "${dir}/fonts.list" || ! -f "${dir}/fonts.dir" || ! -f "${dir}/encodings.dir" ]]; then
        retval=0
    fi

    # Check that no files were added or removed....
    if [[ "${retval}" -ne 0 && "$(cat ${dir}/fonts.list)" != "${fontfiles}" ]] ; then
        retval=0
    fi

    # Check that no files were updated....
    if [[ "${retval}" -ne 0 ]] ; then
        local changed="$(find ${dir}/ -type f -cnewer ${dir}/fonts.dir | awk '$0 !~ /fonts\..*$|^.*\.dir$/ {print}')"

        if [[ -n "${changed}" ]] ; then
            retval=0
        fi
    fi

    # Recreate fonts.list since something changed
    if [[ "${retval}" == 0 ]] ; then
        echo "${fontfiles}" > "${dir}"/fonts.list
    fi

    return ${retval}
}

get_fontdirs() {
    local d
    if [[ $system == 1 ]] ; then
        if [[ $osxfonts == 1 ]] ; then
            find {/System/,/}Library/Fonts -type d
        fi

        for d in "${X11FONTDIR}"/* ; do
            case ${d#${X11FONTDIR}/} in
                conf*|encodings*) ;;
                *) find "$d" -type d ;;
            esac
        done
    else 
	if [[ $osxfonts == 1 && -d "${HOME}/Library/Fonts" ]] ; then
            find "${HOME}/Library/Fonts" -type d
	fi

        if [[ -d "${HOME}/.fonts" ]] ; then
            find "${HOME}/.fonts" -type d
        fi
    fi
}

setup_fontdirs() {
    local x=""
    local fontdirs=""
    local changed="no"

    umask 022

    if [[ $system == 1 ]] ; then
        echo "font_cache: Scanning system font directories to generate X11 font caches"
    else
        echo "font_cache: Scanning user font directories to generate X11 font caches"
    fi

    # Generate the encodings.dir ...
    if [[ $system == 1 ]] ; then
        ${X11DIR}/bin/mkfontdir -n \
            -e ${X11FONTDIR}/encodings \
            -e ${X11FONTDIR}/encodings/large \
            -- ${X11FONTDIR}/encodings
    fi

    OIFS=$IFS
    IFS='
'
    for x in $(get_fontdirs) ; do
        if [[ -d "${x}" ]] && check_dirty "${x}" ; then
            if [[ -z "${fontdirs}" ]] ; then
                fontdirs="${x}"
            else
                fontdirs="${fontdirs}${IFS}${x}"
            fi
        fi
    done

    if [[ -n "${fontdirs}" ]] ; then
        echo "font_cache: Making fonts.dir for updated directories."
        for x in ${fontdirs} ; do
            if [[ $verbose == 1 ]] ; then
                echo "font_cache:    ${x}"
            fi

            # First, generate fonts.scale for scaleable fonts that might be there
            ${X11DIR}/bin/mkfontscale \
                -a ${X11FONTDIR}/encodings/encodings.dir \
                -- ${x}

            # Next, generate fonts.dir
            if [[ $verbose == 1 ]] ; then
                ${X11DIR}/bin/mkfontdir \
                    -e ${X11FONTDIR}/encodings \
                    -e ${X11FONTDIR}/encodings/large \
                    -- ${x}
            else
                ${X11DIR}/bin/mkfontdir \
                    -e ${X11FONTDIR}/encodings \
                    -e ${X11FONTDIR}/encodings/large \
                    -- ${x} > /dev/null
            fi
        done
    fi
    IFS=$OIFS

    # Finally, update fontconfig's cache
    echo "font_cache: Updating FC cache"
    if [[ $system == 1 ]] ; then
        HOME="$(echo ~root)" ${X11DIR}/bin/fc-cache \
            $([[ $force == 1 ]] && echo "-f -r") \
            $([[ $verbose == 1 ]] && echo "-v")
    else
        ${X11DIR}/bin/fc-cache \
            $([[ $force == 1 ]] && echo "-f -r") \
            $([[ $verbose == 1 ]] && echo "-v")
    fi
    echo "font_cache: Done"
}

do_usage() {
    echo "font_cache [options]"
    echo "    -f, --force        : Force cache recreation"
    echo "    -n, --no-osxfonts  : Just cache X11 font directories"
    echo "                         (-n just pertains to XFont cache, not fontconfig)"
    echo "    -s, --system       : Cache system font dirs instead of user dirs"
    echo "    -v, --verbose      : Verbose Output"
}

while [[ $# -gt 0 ]] ; do
    case $1 in
        -s|--system) system=1 ;;
        -f|--force) force=1 ;;
        -v|--verbose) verbose=1 ;;
        -n|--no-osxfonts) osxfonts=0 ;;
        --help) do_usage ; exit 0 ;;
        *) do_usage ; exit 1 ;;
    esac
    shift
done

setup_fontdirs
