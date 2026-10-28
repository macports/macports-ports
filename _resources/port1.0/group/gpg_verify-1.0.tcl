# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup is for ports that verify package-provided gpg signatures
#
# A single signature verification by the Portfile author is sufficient,
# along with the standard checksum phase. The default Portfile behavior
# is not to check gpg signatures, and assume that the Portfile author
# has already done this. The flag `gpg_verify.use_gpg_verification`
# is used within conditionals to run the procedure `gpg_verify.verify_gpg_signature`.
# 
# Usage:
# PortGroup       gpg_verify 1.0
# gpg_verify.use_gpg_verification       yes
# gpg_verify.verify_gpg_signature       pubkey_file signature_file test_file
#
# Note that many PGP key servers are intermittently accessible; therefore, it is
# good practice to include the keyid file in ${filespath}. Also, the checksum
# phase requires at least one hash check of downloaded files, including PGP
# signatures for which hash checks are unnecessary. It is therefore recommended
# to use `size` for signature file checksums, which is often constant for the same
# keyid.
# Example (from the julia Portfile):
# if {[option gpg_verify.use_gpg_verification]} {
#     distfiles-append \
#                     ${name}-${version}-full${extract.suffix}.asc
#     checksums-append \
#                     ${name}-${version}-full${extract.suffix}.asc \
#                     size    866
# }

options gpg_verify.use_gpg_verification
default gpg_verify.use_gpg_verification {no}

options gpg_verify.gpg
default gpg_verify.gpg {${prefix}/bin/gpg}

proc gpg_verify.add_dependencies {} {
    if {[option gpg_verify.use_gpg_verification]} {
        depends_fetch-append port:gnupg2
    }
}
port::register_callback gpg_verify.add_dependencies

options gpg_verify.gpg_homedir
default gpg_verify.gpg_homedir {${workpath}/.gnupg}

pre-checksum {
    if {[geteuid] == 0} {
        xinstall -o ${macportsuser} -d [option gpg_verify.gpg_homedir]
    } else {
        xinstall -d [option gpg_verify.gpg_homedir]
    }
}

proc gpg_verify.verify_gpg_signature {pubkey_file signature_file test_file} {
    # pre-load public key to avoid keyserver downtime issues
    # https://pgp.mit.edu/pks/lookup?op=get&search=0x${gpg_keyid}
    # note: tcl exec will return error if error messages not directed to /dev/null
    system "[option gpg_verify.gpg] \
        --homedir [shellescape [option gpg_verify.gpg_homedir]] \
        --import [shellescape ${pubkey_file}] 2>/dev/null || /usr/bin/true"
    set gpg_verification [exec /bin/sh -c \
        "if [shellescape [option gpg_verify.gpg]] \
            --homedir [shellescape [option gpg_verify.gpg_homedir]] \
            --verify [shellescape ${signature_file}] \
            [shellescape ${test_file}] 2>/dev/null; \
            then echo 'VERIFIED'; else echo 'UNVERIFIED'; fi"]
    if {[string trim ${gpg_verification}] ne "VERIFIED"} {
        error "GPG signature verification failed on ${test_file} with pubkey file ${pubkey_file}."
    }
}
