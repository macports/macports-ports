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


begingroup "Fetching files"
# Download resources in background ASAP but use later.
# Use /usr/bin/curl so that we don't use Homebrew curl.
echo "Fetching getopt..."
/usr/bin/curl -fsSLO "https://github.com/macports/macports-ci-files/releases/download/getopt-1.1.6/getopt-v1.1.6.tar.bz2" &
curl_getopt_pid=$!
echo "Fetching MacPorts..."
/usr/bin/curl -fsSLO "https://github.com/macports/macports-ci-files/releases/download/v${MACPORTS_VERSION}/MacPorts-${OS_MAJOR}.tar.bz2" &
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
