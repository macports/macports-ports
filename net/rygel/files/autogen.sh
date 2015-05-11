#! /bin/sh

# Copyright (C) 2010 Zeeshan Ali (Khattak) <zeeshanak@gnome.org>.
# Copyright (C) 2011 Jens Georg <mail@jensge.org>.
# Copyright (C) 2012 Openismus GmbH.
#
# Author: Zeeshan Ali (Khattak) <zeeshanak@gnome.org>
#         Jens Georg <mail@jensge.org>
#         Murray Cumming <murrayc@openismus.com>
#
# This file is part of Rygel.
#
# Rygel is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Rygel is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

which gnome-autogen.sh || {
    echo "You need to install gnome-common from the GNOME git"
    exit 1
}

DEFAULT_ARGS="--enable-vala --enable-maintainer-mode  --enable-debug  --enable-example-plugins --enable-mediathek-plugin --enable-gst-launch-plugin --disable-strict-valac"

mkdir -p m4

if [ "x$1" = "xdevel" ]; then
    DEFAULT_ARGS="$DEFAULT_ARGS --enable-uninstalled --enable-debug --disable-apidocs"
    shift
elif [ "x$1" = "xrelease" ]; then
    DEFAULT_ARGS="$DEFAULT_ARGS --enable-apidocs --disable-debug"
    shift
fi

# require automake 1.11 for vala support
REQUIRED_AUTOMAKE_VERSION=1.11 \
REQUIRED_AUTOCONF_VERSION=2.64 \
REQUIRED_LIBTOOL_VERSION=2.2.6 \
REQUIRED_INTLTOOL_VERSION=0.40.0 \
. gnome-autogen.sh $DEFAULT_ARGS "$@"
