#!/bin/bash

set -e

OS_MAJOR=$(uname -r | cut -f 1 -d .)
OS_ARCH=$(uname -m)
case "$OS_ARCH" in
    i586|i686|x86_64)
        OS_ARCH=i386
        ;;
esac

echo "::group::Disabling Spotlight"
# Disable Spotlight indexing. We don't need it, and it might cost performance
sudo mdutil -a -i off
echo "::endgroup::"


echo "::group::Uninstalling Homebrew"

# Move directories to /opt/off
echo "Moving directories..."
sudo mkdir /opt/off
/usr/bin/sudo /usr/bin/find /usr/local -mindepth 1 -maxdepth 1 -type d -print -exec /bin/mv {} /opt/off/ \;

# Unlink files
echo "Removing files..."
/usr/bin/sudo /usr/bin/find /usr/local -mindepth 1 -maxdepth 1 -type f -print -delete

# Rehash to forget about the deleted files
hash -r
echo "::endgroup::"

echo "::group::Installing MacPorts"
echo "Fetching..."
# Download resources in background ASAP but use later; do this after cleaning
# up Homebrew so that we don't end up using their curl!
curl -fsSLO "https://dl.bintray.com/macports-ci-env/macports-base/MacPorts-${OS_MAJOR}.tar.bz2" &
curl_mpbase_pid=$!
curl -fsSLO "https://dl.bintray.com/macports-ci-bot/getopt/getopt-v1.1.6.tar.bz2" &
curl_getopt_pid=$!

# Download and install MacPorts built by https://github.com/macports/macports-base/tree/master/.github
wait $curl_mpbase_pid

echo "Extracting..."
sudo tar -xpf "MacPorts-${OS_MAJOR}.tar.bz2" -C /
rm -f "MacPorts-${OS_MAJOR}.tar.bz2"
echo "::endgroup::"


echo "::group::Configuring MacPorts"
# Set PATH for portindex
source /opt/local/share/macports/setupenv.bash
# Set ports tree to $PWD/ports
sudo sed -i "" "s|rsync://rsync.macports.org/macports/release/tarballs/ports.tar|file://${PWD}/ports|; /^file:/s/default/nosync,default/" /opt/local/etc/macports/sources.conf
# CI is not interactive
echo "ui_interactive no" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Only download from the CDN, not the mirrors
echo "host_blacklist *.distfiles.macports.org *.packages.macports.org" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Try downloading archives from the private server after trying the public server
echo "archive_site_local https://packages.macports.org/:tbz2 https://packages-private.macports.org/:tbz2" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
# Prefer to get archives from the public server instead of the private server
# preferred_hosts has no effect on archive_site_local
# See https://trac.macports.org/ticket/57720
#echo "preferred_hosts packages.macports.org" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
echo "::endgroup::"

echo "::group::Generating PortIndex"
# Update PortIndex
curl -L "https://ftp.fau.de/macports/release/ports/PortIndex_darwin_${OS_MAJOR}_${OS_ARCH}/PortIndex" -o ports/PortIndex
## Run portindex on recent commits if PR is newer
git -C ports/ remote add macports https://github.com/macports/macports-ports.git
git -C ports/ fetch macports master
git -C ports/ checkout -qf macports/master~10
git -C ports/ checkout -qf -
git -C ports/ checkout -qf "$(git -C ports/ merge-base macports/master HEAD)"
## Ignore portindex errors on common ancestor
(cd ports/ && portindex)
git -C ports/ checkout -qf -
(cd ports/ && portindex -e)
echo "::endgroup::"

echo "::group::Running postflight"
# Create macports user
echo "Postflight..."
sudo /opt/local/libexec/macports/postflight/postflight
echo "::endgroup::"

echo "::group::Installing getopt"
# Install getopt required by mpbb
wait $curl_getopt_pid
echo "Extracting..."
sudo tar -xpf "getopt-v1.1.6.tar.bz2" -C /
echo "::endgroup::"
