#!/bin/sh

# Expects to be run with PWD as the destroot for libkrun

# TODO: The `1` here is from the compatibility version and when libkrun 2 is released this will
#       need to be templated from the Portfile depending on the version being installed.
target_dylib="${MP_PREFIX}/lib/libkrun-efi.1.dylib"
# target_dylib="${MP_PREFIX}/lib/libkrun.1.dylib"

# So we can print all errors before exiting.
exit_status=0

# PWD no trailing slash, MP_PREFIX has.
for f in "${PWD}${MP_PREFIX}"/lib/*.dylib; do
    rpaths="$(otool -L "$f")"

    # So we can print out the otool output without having to run it again.
    grep "$target_dylib" > /dev/null << EOF
"$rpaths"
EOF

    if [ $? -gt 0 ]; then
        printf 'ERROR: %s rpath does not match prefix `%s`\n%s\n' "$f" "$MP_PREFIX" "$rpaths"
        exit_status=1
    fi
done

exit "$exit_status"
