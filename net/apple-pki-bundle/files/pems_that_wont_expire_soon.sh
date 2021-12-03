#!/usr/bin/env bash

# Usage: pems_that_wont_expire_soon.sh testpems.pem

DIR="${TMPDIR}/testpems.$$"

mkdir -p "${DIR}"
trap "rm -rf '${DIR}'" EXIT
( cd "${DIR}" && gcsplit -f cert- -b '%03x' -s -z - '/^-----END CERTIFICATE-----$/+1' '{*}' ) < "$1"

for c in "${DIR}"/cert-* ; do
    # use the pem if its expiration is more than a week away
    if openssl x509 -checkend 604800 -noout -in "${c}" 1> /dev/null 2>&1; then
        cat "${c}"
    fi
done

rm -rf "${DIR}"
