#!/bin/bash

#
# Obtain path to script.
#
# Note that 'grealpath' provides reliable soft-link resolution, without requiring
# any Bash gymnastics.
#
script_file=$(grealpath "${0}")
script_dir=$(dirname "${script_file}")

cmd="${script_dir}/@@MACPORTS_MAME_EXECUTABLE@@"
bgfx_path="${script_dir}/bgfx"
languagepath="${script_dir}/language"

cmdline=()
cmdline+=( "${cmd}" )
cmdline+=( -bgfx_path "${bgfx_path}" )
cmdline+=( -languagepath "${languagepath}" )

# Note that Mame handles duplicate arguments, using the last one found.
# Net-Net, there's no need to check whether the user specified the same
# parameters, as theirs will take precedence.

"${cmdline[@]}" \
"${@}"

