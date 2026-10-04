#!/bin/sh
# rosetta-exe-wrapper.sh
#
# Meson `exe_wrapper` for the x86_64-darwin cross file, used when building
# an x86_64 slice as part of a +universal build on an arm64 host.
#
# Meson invokes this as:  rosetta-exe-wrapper.sh <binary> [args...]
#
# x86_64 Mach-O binaries run directly on Apple Silicon via Rosetta 2 (no
# translation shim to invoke, unlike qemu-style wrappers on Linux) -- but
# only if Rosetta is actually installed. This wrapper checks that once,
# up front, so a missing install produces one clear error message instead
# of an obscure crash deep inside g-ir-scanner or a test binary.

set -eu

if [ "$#" -eq 0 ]; then
    echo "rosetta-exe-wrapper: no command given" >&2
    exit 1
fi

build_arch="$(/usr/bin/uname -m)"

# Only relevant on Apple Silicon; on a native x86_64 host there's nothing
# to translate, so just run it.
if [ "${build_arch}" = "arm64" ]; then
    if ! /usr/bin/arch -x86_64 /usr/bin/true >/dev/null 2>&1; then
        cat >&2 <<EOF
rosetta-exe-wrapper: cannot execute x86_64 binaries on this arm64 host.

Building +universal requires Rosetta 2 to run x86_64 binaries produced
during the build (e.g. gobject-introspection scanning, test suites).
Install it with:

    softwareupdate --install-rosetta --agree-to-license

then retry the build.
EOF
        exit 1
    fi
fi

exec "$@"
