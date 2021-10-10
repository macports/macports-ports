#!/bin/bash

set -e

printtag() {
    # Azure Pipelines tag format
    echo "##[$1]${2-}"
}

begingroup() {
    printtag "group" "$1"
}

endgroup() {
    printtag "endgroup"
}

MACPORTS_VERSION=2.7.1

OS_MAJOR=$(uname -r | cut -f 1 -d .)
OS_ARCH=$(uname -m)
case "$OS_ARCH" in
    i586|i686|x86_64)
        OS_ARCH=i386
        ;;
esac

begingroup "Removed unused certificates"
# macOC 10.14 uses curl linked against LibreSSL
# which gave up to checking trusted root as soon as first certificate is expired
# by removing expired certificate, it allows to use the second one: CN=ISRG Root X1
echo "Removing expired let's encryption root CA..."
cat <<EOF | /usr/bin/sudo /usr/bin/patch --quiet -l /etc/ssl/cert.pem
--- /etc/ssl/cert.pem.orign	2021-10-10 00:41:28.000000000 +0200
+++ /etc/ssl/cert.pem	2021-10-10 00:42:07.000000000 +0200
@@ -1127,49 +1127,6 @@
 9w4LTJxoeHtxMcfrHuBnQfO3oKfN5XozNmr6mis=
 -----END CERTIFICATE-----

-### Digital Signature Trust Co.
-
-=== /O=Digital Signature Trust Co./CN=DST Root CA X3
-Certificate:
-    Data:
-        Version: 3 (0x2)
-        Serial Number:
-            44:af:b0:80:d6:a3:27:ba:89:30:39:86:2e:f8:40:6b
-    Signature Algorithm: sha1WithRSAEncryption
-        Validity
-            Not Before: Sep 30 21:12:19 2000 GMT
-            Not After : Sep 30 14:01:15 2021 GMT
-        Subject: O=Digital Signature Trust Co., CN=DST Root CA X3
-        X509v3 extensions:
-            X509v3 Basic Constraints: critical
-                CA:TRUE
-            X509v3 Key Usage: critical
-                Certificate Sign, CRL Sign
-            X509v3 Subject Key Identifier:
-                C4:A7:B1:A4:7B:2C:71:FA:DB:E1:4B:90:75:FF:C4:15:60:85:89:10
-SHA1 Fingerprint=DA:C9:02:4F:54:D8:F6:DF:94:93:5F:B1:73:26:38:CA:6A:D7:7C:13
-SHA256 Fingerprint=06:87:26:03:31:A7:24:03:D9:09:F1:05:E6:9B:CF:0D:32:E1:BD:24:93:FF:C6:D9:20:6D:11:BC:D6:77:07:39
------BEGIN CERTIFICATE-----
-MIIDSjCCAjKgAwIBAgIQRK+wgNajJ7qJMDmGLvhAazANBgkqhkiG9w0BAQUFADA/
-MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
-DkRTVCBSb290IENBIFgzMB4XDTAwMDkzMDIxMTIxOVoXDTIxMDkzMDE0MDExNVow
-PzEkMCIGA1UEChMbRGlnaXRhbCBTaWduYXR1cmUgVHJ1c3QgQ28uMRcwFQYDVQQD
-Ew5EU1QgUm9vdCBDQSBYMzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
-AN+v6ZdQCINXtMxiZfaQguzH0yxrMMpb7NnDfcdAwRgUi+DoM3ZJKuM/IUmTrE4O
-rz5Iy2Xu/NMhD2XSKtkyj4zl93ewEnu1lcCJo6m67XMuegwGMoOifooUMM0RoOEq
-OLl5CjH9UL2AZd+3UWODyOKIYepLYYHsUmu5ouJLGiifSKOeDNoJjj4XLh7dIN9b
-xiqKqy69cK3FCxolkHRyxXtqqzTWMIn/5WgTe1QLyNau7Fqckh49ZLOMxt+/yUFw
-7BZy1SbsOFU5Q9D8/RhcQPGX69Wam40dutolucbY38EVAjqr2m7xPi71XAicPNaD
-aeQQmxkqtilX4+U9m5/wAl0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
-HQ8BAf8EBAMCAQYwHQYDVR0OBBYEFMSnsaR7LHH62+FLkHX/xBVghYkQMA0GCSqG
-SIb3DQEBBQUAA4IBAQCjGiybFwBcqR7uKGY3Or+Dxz9LwwmglSBd49lZRNI+DT69
-ikugdB/OEIKcdBodfpga3csTS7MgROSR6cz8faXbauX+5v3gTt23ADq1cEmv8uXr
-AvHRAosZy5Q6XkjEGB5YGV8eAlrwDPGxrancWYaLbumR9YbK+rlmM6pZW87ipxZz
-R8srzJmwN0jP41ZL9c8PDHIyh8bwRLtTcm1D9SZImlJnt1ir/md2cXjbDaJWFBM5
-JDGFoqgCWjBH4d1QB7wCCZAA62RjYJsWvIjJEubSfZGL+T0yjWW06XyxV3bqxbYo
-Ob8VZRzI9neWagqNdwvYkQsEjgfbKbYK7p2CNTUQ
------END CERTIFICATE-----
-
 ### Entrust, Inc.

 === /C=US/O=Entrust, Inc./OU=See www.entrust.net/legal-terms/OU=(c) 2009 Entrust, Inc. - for authorized use only/CN=Entrust Root Certification Authority - G2
EOF
endgroup


begingroup "Fetching files"
# Download resources in background ASAP but use later.
# Use /usr/bin/curl so that we don't use Homebrew curl.
echo "Fetching getopt..."
/usr/bin/curl -fsSLO "https://distfiles.macports.org/_ci/getopt/getopt-v1.1.6.tar.bz2" &
curl_getopt_pid=$!
echo "Fetching MacPorts..."
/usr/bin/curl -fsSLO "https://github.com/macports/macports-ports/files/7318181/MacPorts-${OS_MAJOR}.tar.bz2.gz" &
curl_mpbase_pid=$!
echo "Fetching PortIndex..."
/usr/bin/curl -fsSLo ports/PortIndex "https://ftp.fau.de/macports/release/ports/PortIndex_darwin_${OS_MAJOR}_${OS_ARCH}/PortIndex" &
curl_portindex_pid=$!
endgroup


begingroup "Info"
echo "macOS version: $(sw_vers -productVersion)"
echo "IP address: $(/usr/bin/curl -fsS https://www-origin.macports.org/ip.php)"
/usr/bin/curl -fsSIo /dev/null https://packages-private.macports.org/.org.macports.packages-private.healthcheck.txt && private_packages_available=yes || private_packages_available=no
echo "Can reach private packages server: $private_packages_available"
endgroup


begingroup "Disabling Spotlight"
# Disable Spotlight indexing. We don't need it, and it might cost performance
sudo mdutil -a -i off
endgroup


begingroup "Uninstalling Homebrew"
# Move directories to /opt/off
echo "Moving directories..."
sudo mkdir /opt/off
/usr/bin/sudo /usr/bin/find /usr/local -mindepth 1 -maxdepth 1 -type d -print -exec /bin/mv {} /opt/off/ \;

# Unlink files
echo "Removing files..."
/usr/bin/sudo /usr/bin/find /usr/local -mindepth 1 -maxdepth 1 -type f -print -delete

# Rehash to forget about the deleted files
hash -r
endgroup


begingroup "Installing getopt"
# Install getopt required by mpbb
wait $curl_getopt_pid
echo "Extracting..."
sudo tar -xpf "getopt-v1.1.6.tar.bz2" -C /
rm -f "getopt-v1.1.6.tar.bz2"
endgroup


begingroup "Installing MacPorts"
# Install MacPorts built by https://github.com/macports/macports-base/tree/master/.github
wait $curl_mpbase_pid
echo "Extracting..."
gunzip "MacPorts-${OS_MAJOR}.tar.bz2.gz"
sudo tar -xpf "MacPorts-${OS_MAJOR}.tar.bz2" -C /
rm -f "MacPorts-${OS_MAJOR}.tar.bz2"
endgroup


begingroup "Configuring MacPorts"
# Set PATH for portindex
source /opt/local/share/macports/setupenv.bash
# Set ports tree to $PWD/ports
sudo sed -i "" "s|rsync://rsync.macports.org/macports/release/tarballs/ports.tar|file://${PWD}/ports|; /^file:/s/default/nosync,default/" /opt/local/etc/macports/sources.conf
# CI is not interactive
echo "ui_interactive no" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Only download from the CDN, not the mirrors
echo "host_blacklist *.distfiles.macports.org *.packages.macports.org" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Also try downloading archives from the private server
echo "archive_site_local https://packages-private.macports.org/:tbz2" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Prefer to get archives from the public server instead of the private server
# preferred_hosts has no effect on archive_site_local
# See https://trac.macports.org/ticket/57720
#echo "preferred_hosts packages.macports.org" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
endgroup


begingroup "Updating PortIndex"
## Run portindex on recent commits if PR is newer
git -C ports/ remote add macports https://github.com/macports/macports-ports.git
git -C ports/ fetch macports master
git -C ports/ checkout -qf macports/master~10
git -C ports/ checkout -qf -
git -C ports/ checkout -qf "$(git -C ports/ merge-base macports/master HEAD)"
## Ignore portindex errors on common ancestor
wait $curl_portindex_pid
(cd ports/ && portindex)
git -C ports/ checkout -qf -
(cd ports/ && portindex -e)
endgroup


begingroup "Running postflight"
# Create macports user
sudo /opt/local/libexec/macports/postflight/postflight
endgroup
