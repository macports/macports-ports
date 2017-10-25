#!/bin/bash
set -e
curl -fsSLO "https://raw.githubusercontent.com/Homebrew/install/master/uninstall"
chmod 0755 uninstall && ./uninstall -fq && rm -f uninstall
/usr/bin/sudo /usr/bin/find /usr/local -mindepth 2 -delete && hash -r
export OS_MAJOR=$(uname -r | cut -f 1 -d .)
curl -fsSLO "https://dl.bintray.com/macports-ci-bot/macports-base/MacPorts-${OS_MAJOR}.tar.bz2"
sudo tar -xpf "MacPorts-${OS_MAJOR}.tar.bz2" -C /
rm -f "MacPorts-${OS_MAJOR}.tar.bz2"
unset CC && source /opt/local/share/macports/setupenv.bash
sudo sed -i "" "s|rsync://rsync.macports.org/macports/release/tarballs/ports.tar|file://${PWD}|; /^file:/s/default/nosync,default/" /opt/local/etc/macports/sources.conf
echo "ui_interactive no" | sudo tee -a /opt/local/etc/macports/macports.conf
rsync -zvl "rsync://rsync.macports.org/macports/release/ports/PortIndex_darwin_${OS_MAJOR}_i386/PortIndex*" .
git remote add macports https://github.com/macports/macports-ports.git
git fetch macports master
git checkout -qf macports/master
git checkout -qf -
sudo patch /opt/local/bin/portindex _ci/patch-portindex.diff
portindex
sudo /opt/local/postflight && sudo rm -f /opt/local/postflight
git clone --depth 1 https://github.com/macports/mpbb.git ../mpbb
export PATH="${PWD}/../mpbb:$PATH"
curl -fsSLO "https://dl.bintray.com/macports-ci-bot/getopt/getopt-v1.1.6.tar.bz2"
sudo tar -xpf "getopt-v1.1.6.tar.bz2" -C /
export PATH="/opt/mports/bin:$PATH" && hash -r
curl -fsSLO "https://github.com/macports/mpbot-github/releases/download/v0.0.1/runner"
chmod 0755 runner
