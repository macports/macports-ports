#!/bin/bash

PFILES=$(find $(port dir hdf5)/../.. -name Portfile \
           -exec grep -l 'port[^ ]*hdf5' '{}' '+')
echo -n "Checking: "
for x in $PFILES; do
  echo -n "$x"
  pushd $(dirname $x) > /dev/null
  port info | grep -Eq '(Dependencies.*hdf5|Sub-ports)'
  if [ $? -ne 0 ]; then
    popd > /dev/null
    echo
    continue
  fi
  popd > /dev/null
  grep -q revision $x || { echo " NO REVISION" ; continue ; }
  echo " (bumping)"
  awk '/revision/{sub($2, $2+1)} {print}' < $x > $x.revup && mv $x.revup $x
done
echo 'Done!'
