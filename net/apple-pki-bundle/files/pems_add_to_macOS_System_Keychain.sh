#!/usr/bin/env bash

# Usage: pems_add_to_macOS_System_Keychain.sh trustedroot.pem

# change to true to add the trusted certicates
if false; then
    DIR="${TMPDIR}/trustedroot.$$"

    mkdir -p "${DIR}"
    trap "rm -rf '${DIR}'" EXIT
    ( cd "${DIR}" && gcsplit -f cert- -b '%03x' -s -z - '/^-----END CERTIFICATE-----$/+1' '{*}' ) < "$1"

    for c in "${DIR}"/cert-* ; do
        # use the pem if its expiration is more than a week away
        if openssl x509 -checkend 604800 -noout -in "${c}" 1> /dev/null 2>&1; then
            security -v add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "${c}"
        fi
    done
else
    cat <<'INSTRUCTIONS'
Edit this script to add certificates from a trusted PEM file
to the macOS System Keychain /Library/Keychains/System.keychain.
Please make sure that you have a reliable backup of this file
before running the script.
INSTRUCTIONS
fi

rm -rf "${DIR}"
