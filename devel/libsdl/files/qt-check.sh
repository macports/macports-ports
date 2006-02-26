#!/bin/bash

qtver=`/usr/bin/grep Version /System/Library/Frameworks/QuickTime.framework/Headers/QuickTime.h | sed 's/.*7.0.\([0-9]\)/\1/'`

if [[ ${qtver} == "4" ]]; then
  echo 
  echo Installation of libSDL is exiting because it believes you have
  echo QuickTime version 7.0.${qtver} installed.
  echo
  echo On Mac OS 10.3/XCode 1.5, you must have QuickTime 7.0.3
  echo or lower if you want to install the libSDL port.
  echo
  echo If you have QuickTime 7.0.4, you can downgrade to 7.0.1:
  echo http://www.apple.com/support/downloads/quicktime701reinstallerforquicktime704.html
  echo 
  echo If you actually have QuickTime 7.0.1 and you think
  echo you should not be receiving this error message, you
  echo can report the problem here:
  echo http://bugzilla.opendarwin.org/show_bug.cgi?id=1933
  exit 1
else
  exit 0
fi

