#!/usr/bin/env bash

# Usage: pems_not_in_pemfile.sh testpems.pem trustroot.pem

declare -A testpems
declare -A trustroot

DIR1="${TMPDIR}/${-+testpems}.$$"
DIR2="${TMPDIR}/${-+trustroot}.$$"

mkdir -p "${DIR1}" "${DIR2}"
trap "rm -rf '${DIR1}' '${DIR2}'" EXIT
( cd "${DIR1}" && gcsplit -f cert- -b '%03x' -s -z - '/^-----END CERTIFICATE-----$/+1' '{*}' ) < "$1"
( cd "${DIR2}" && gcsplit -f cert- -b '%03x' -s -z - '/^-----END CERTIFICATE-----$/+1' '{*}' ) < "$2"

for c in "${DIR2}"/cert-* ; do
    # use the pem if its expiration is more than a week away
    if openssl x509 -checkend 604800 -noout -in "${c}" 1> /dev/null 2>&1; then
        SHA1=$(openssl x509 -noout -fingerprint -sha1 -inform pem -in "${c}" 2> /dev/null \
            | sed "s|^SHA1 Fingerprint=||" | sed "s|:||g")
        trustroot+=([${SHA1}]=${c})
    fi
done

for c in "${DIR1}"/cert-* ; do
    # use the pem if its expiration is more than a week away
    if openssl x509 -checkend 604800 -noout -in "${c}" 1> /dev/null 2>&1; then
        SHA1=$(openssl x509 -noout -fingerprint -sha1 -inform pem -in "${c}" 2> /dev/null \
            | sed "s|^SHA1 Fingerprint=||" | sed "s|:||g")
        # add the pem if it's not already in the a.a.'s trustroot or testpems
        if ! [ ${trustroot[${SHA1}]+_} ] && ! [ ${testpems[${SHA1}]+_} ]; then
            testpems+=([${SHA1}]=${c})
        fi
    fi
done

# paste -d= <(printf "%s\n" "${!testpems[@]}") <(printf "%s\n" "${testpems[@]}")

for ky in "${!testpems[@]}"; do
    cat "${testpems[$ky]}"
done

rm -rf "${DIR1}" "${DIR2}"
