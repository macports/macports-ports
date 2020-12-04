#!/bin/bash

#
# Obtain path to script.
#
# Note that 'grealpath' provides reliable soft-link resolution, without requiring
# any Bash gymnastics.
#
script_file=$(grealpath "${0}")
script_dir=$(dirname "${script_file}")

cd "${script_dir}"

./@@MACPORTS_MAME_EXECUTABLE@@ "${@}"

