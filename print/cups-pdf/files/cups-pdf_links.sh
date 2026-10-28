#!/bin/sh
#
# Create links necessary for CUPS to see cups-pdf

if [[ `/usr/bin/id -u` != 0 ]]; then
   exec /usr/bin/sudo $0
fi

if [[ ! -f /usr/libexec/cups/backend/cups-pdf ]]; then
   echo "Creating symlink /usr/libexec/cups/backend/cups-pdf"
   ln -s @@PREFIX@@/libexec/cups/backend/cups-pdf /usr/libexec/cups/backend/
fi
if [[ ! -f /usr/share/cups/model/CUPS-PDF.ppd ]]; then
   echo "Creating symlink /usr/share/cups/model/CUPS-PDF.ppd"
   ln -s @@PREFIX@@/share/cups/model/CUPS-PDF.ppd /usr/share/cups/model/
fi

