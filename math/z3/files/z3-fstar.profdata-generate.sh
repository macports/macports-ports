#!/bin/sh

elog() {
	echo "$@" >/dev/stderr
}

print_usage() {
	local arg0="$1"
	elog "Usage: $arg0 [-hn] [-l <llvm-profdata>] [-z <z3>] [-j <jobs>] [-o <output archive>] <everest src>"
	elog "  -h   print this help"
	elog "  -q   enable SMT query logging"
	elog "  -n   skip build (only perform merge and archiving)"
	elog "  -m   skip build and merge (only perform archiving)"
}

# Search for a required binary
req_bin() {
	local name="$1"
	local path
	if ! path=$(/usr/bin/which "${name}" 2>/dev/null) || [ ! -x "${path}" ]; then
		elog "${name} not found"
		return 1
	fi

	realpath "${path}" || return $?
	return 0
}

# Parse arguments
EV_PROFDATA_ARCHIVE=""
EV_LLVM_PROFDATA="llvm-profdata-mp-10"
EV_Z3="z3-fstar"
EV_JOBS=1
EV_QLOG=0
EV_SKIP_BUILD=0
EV_SKIP_MERGE=0

args=`getopt hqnmj:z:l:o: $*`
if [ $? -ne 0 ]; then
	print_usage "$0"
	exit 2
fi
set -- $args

while :; do
	case "$1" in
		-h)
			print_usage "$0"
			exit 0
			;;
		-j)
			EV_JOBS="$2"
			shift; shift
			;;
		-z)
			EV_Z3="$2"
			shift; shift
			;;
		-l)
			EV_LLVM_PROFDATA="$2"
			shift; shift
			;;
		-o)
			EV_PROFDATA_ARCHIVE="$2"
			shift; shift
			;;
		-q)
			EV_QLOG="1"
			shift
			;;
		-n)
			EV_SKIP_BUILD="1"
			shift
			;;
		-m)
			EV_SKIP_BUILD="1"
			EV_SKIP_MERGE="1"
			shift
			;;
		--)
			shift; break
			;;
		esac
done

if [ $# -lt 1 ]; then
	print_usage "$0"
	exit 1
fi

EV_SRC="$(realpath "$1")" || exit $?
if [ ! -d "${EV_SRC}" ]; then
	elog "No such directory: ${EV_SRC}"
	exit 1
fi

EV_SH="${EV_SRC}/everest"

EV_SH=$(req_bin "${EV_SH}") || exit $?
EV_Z3=$(req_bin "${EV_Z3}") || exit $?
EV_LLVM_PROFDATA=$(req_bin "${EV_LLVM_PROFDATA}") || exit $?

EV_PROFILE_DIR="${EV_SRC}/profiling"
EV_LOG="${EV_PROFILE_DIR}/build.log"
EV_PROFILE_BIN_DIR="${EV_PROFILE_DIR}/bin"
EV_PROFRAW_OUTPUT_FILE="${EV_PROFILE_DIR}/z3-fstar-%m-%p.profraw"
EV_PROFDATA_OUTPUT_FILE="${EV_PROFILE_DIR}/z3-fstar.profdata"

if [ -z "${EV_PROFDATA_ARCHIVE}" ]; then
	EV_PROFDATA_ARCHIVE="${EV_PROFDATA_OUTPUT_FILE}.tar.xz"
fi

elog "Configuration:"
elog "  everest:        ${EV_SRC}"
elog "  llvm-profdata:  ${EV_LLVM_PROFDATA}"
elog "  z3:             ${EV_Z3}"
elog "  archive output: ${EV_PROFDATA_ARCHIVE}"
elog "  build log:      ${EV_LOG}"
elog "  build jobs:     ${EV_JOBS}"

mkdir -p "${EV_PROFILE_BIN_DIR}" || exit $?
ln -sF "${EV_Z3}" "${EV_PROFILE_BIN_DIR}/z3"  || exit $?

if [ "${EV_SKIP_BUILD}" -eq 1 ]; then
	elog "\nSkipping build..."
else
	if [ ${EV_QLOG} -eq 1 ]; then
		EV_OTHERFLAGS="--log_queries"
	fi

	elog "\nBuilding ..."
	env \
		PATH="${EV_PROFILE_BIN_DIR}:$PATH" \
		LLVM_PROFILE_FILE="${EV_PROFRAW_OUTPUT_FILE}" \
		OTHERFLAGS="${EV_OTHERFLAGS}" \
		"${EV_SH}" \
		-j "${EV_JOBS}" \
		make >"${EV_LOG}" 2>&1

	if [ $? -ne 0 ]; then
		elog "Build failed; see ${EV_LOG}"
		exit 1
	fi
fi

if [ "${EV_SKIP_MERGE}" -eq 1 ]; then
	elog "Skipping merge..."
else
	elog "Merging profiles..."
	"${EV_LLVM_PROFDATA}" \
		merge \
		--failure-mode=all \
		--output="${EV_PROFDATA_OUTPUT_FILE}" \
		"${EV_PROFILE_DIR}"/z3-fstar-*.profraw || exit $?
fi

elog "Generating ${EV_PROFDATA_ARCHIVE}..."

tar \
	-Jcf "${EV_PROFDATA_ARCHIVE}" \
	-C "$(dirname "${EV_PROFDATA_OUTPUT_FILE}")" \
	"$(basename "${EV_PROFDATA_OUTPUT_FILE}")" || exit $?
