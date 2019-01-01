#!/bin/bash
set -e
# Uninstall Homebrew
curl -fsSLO "https://raw.githubusercontent.com/Homebrew/install/master/uninstall"
chmod 0755 uninstall && ./uninstall -fq && rm -f uninstall
# Clean /usr/local
/usr/bin/sudo /usr/bin/find /usr/local -mindepth 2 -delete && hash -r
# Download and install MacPorts built by https://github.com/macports/macports-base/blob/travis-ci/.travis.yml
OS_MAJOR=$(uname -r | cut -f 1 -d .)
curl -fsSLO "https://dl.bintray.com/macports-ci-bot/macports-base/MacPorts-${OS_MAJOR}.tar.bz2"
sudo tar -xpf "MacPorts-${OS_MAJOR}.tar.bz2" -C /
rm -f "MacPorts-${OS_MAJOR}.tar.bz2"
# Prepare environment variables: clear CC and set PATH for port
unset CC && source /opt/local/share/macports/setupenv.bash
# Set ports tree to $PWD
sudo sed -i "" "s|rsync://rsync.macports.org/macports/release/tarballs/ports.tar|file://${PWD}|; /^file:/s/default/nosync,default/" /opt/local/etc/macports/sources.conf
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
# Fix bug in MacPorts 2.5.4 that makes archive_site_local not work at all
# See https://trac.macports.org/ticket/57717
sudo sed -E -i "" "s,{} ({} ARCHIVE_SITE_LOCAL),\1," /opt/local/libexec/macports/lib/package1.0/portarchivefetch.tcl
# Fix bug in MacPorts 2.5.4 that mishandles multiple URLs in archive_site_local
# See https://trac.macports.org/ticket/57718
sudo sed -E -i "" 's,\[list (\$env\(\$senv\))\],\1,' /opt/local/libexec/macports/lib/port1.0/fetch_common.tcl
# Update PortIndex
rsync --no-motd -zvl "rsync://rsync.macports.org/macports/release/ports/PortIndex_darwin_${OS_MAJOR}_i386/PortIndex*" .
git remote add macports https://github.com/macports/macports-ports.git
git fetch macports master
git checkout -qf macports/master
git checkout -qf -
portindex -e
# Create macports user
sudo /opt/local/postflight && sudo rm -f /opt/local/postflight
# Install mpbb and its dependency getopt
git clone --depth 1 https://github.com/macports/mpbb.git ../mpbb
curl -fsSLO "https://dl.bintray.com/macports-ci-bot/getopt/getopt-v1.1.6.tar.bz2"
sudo tar -xpf "getopt-v1.1.6.tar.bz2" -C /
# Download and run CI runner
curl -fsSLO "https://github.com/macports/mpbot-github/releases/download/v0.0.1/runner"
chmod 0755 runner

# Work around broken gen_bridge_metadata / bridgesupportparser.bundle on High Sierra and Mojave
# See https://trac.macports.org/ticket/54939
if ! /usr/bin/gen_bridge_metadata --version >/dev/null 2>&1; then
    sudo ln -s XcodeDefault.xctoolchain "$(xcode-select -p)"/Toolchains/OSX"$(sw_vers -productVersion | cut -d. -f1-2)".xctoolchain
fi
