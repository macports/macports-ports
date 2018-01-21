#!/bin/zsh
# -*- coding: utf-8; tab-width: 2; indent-tabs-mode: nil; sh-basic-offset: 2; sh-indentation: 2; -*- vim:fenc=utf-8:et:sw=2:ts=2:sts=2
#
# Copyright (C) 2018 Enrico M. Crisostomo
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
setopt local_options
setopt local_traps
unsetopt glob_subst

set -o errexit
set -o nounset

PROGNAME=$0
VERSION=1.0.0

typeset -a required_programs=( openssl )

mp_check_required_programs()
{
  for p in ${required_programs}
  do
    command -v ${p} > /dev/null 2>&1 ||
      {
        >&2 print -- Cannot find ${p}.
        return 1
      }
  done
}

mp_print_usage()
{
  print -- "${PROGNAME} ${VERSION}"
  print
  print -- "Usage:"
  print -- "${PROGNAME} [-h]"
  print
  print -- "Options:"
  print -- " -h         Show this help."
  print
  print -- "Report bugs to <https://github.com/emcrisostomo/Time-Machine-Cleanup>."
}

mp_parse_opts()
{
  while getopts ":h" opt
  do
    case $opt in
      h)
        print_usage
        exit 0
        ;;
      \?)
        >&2 print -- "Invalid option -${OPTARG}."
        exit 1
        ;;
      :)
        >&2 print -- "Missing argument to -${OPTARG}."
        exit 1
        ;;
    esac
  done

  ARGS_PROCESSED=$((OPTIND - 1))
}

mp_health_checks()
{
  mp_check_required_programs

  (( $# > 0 )) ||
    {
      >&2 print -- "Required arguments missing."
      return 2
    }
}

mp_calculate_checksums()
{
  (( $# == 1 )) ||
    {
      >&2 print -- "calculate_checksums: missing argument"
      return 1
    }

  openssl md5 ${1}
  openssl rmd160 ${1}
  openssl sha256 ${1}
  LC_ALL=C ls -l ${1} | awk '{ print "SIZE('${1}')= ", $5; }'
}

# Main
mp_parse_opts $* && shift ${ARGS_PROCESSED}

mp_health_checks $*

for i in $*
do
  mp_calculate_checksums ${1}
done

# Local variables:
# coding: utf-8
# mode: sh
# eval: (sh-set-shell "zsh")
# tab-width: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# sh-indentation: 2
# End:
