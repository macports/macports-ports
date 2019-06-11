#!/bin/sh
#
# clamdscan or clamscan applied to $*
#

# License GPL-3, https://www.gnu.org/licenses/gpl-3.0.en.html

EVENT=("$@")

#
# Init
#
prefix=@PREFIX@

CLAMAV_SERVER_QUARANTINE=${CLAMAV_SERVER_QUARANTINE:=${prefix%/*}/Quarantine}

# Default: use clamdscan if clamd is running and uid is root; otherwise:
# clamscan with an explicit configuration imported from ${prefix}/etc/clamd.conf
CLAMD_CONF="${prefix}/etc/clamd.conf"
IFS=$'\n'
CROSS_FS=(`/usr/bin/egrep -e '^[[:space:]]*CrossFilesystems\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*CrossFilesystems[[:space:]]+/--cross-fs=/'`)
FOLLOW_DIR_SYMLINKS=(`/usr/bin/egrep -e '^[[:space:]]*FollowDirectorySymlinks\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*FollowDirectorySymlinks[[:space:]]+/--follow-dir-symlinks=/'`)
FOLLOW_FILE_SYMLINKS=(`/usr/bin/egrep -e '^[[:space:]]*FollowFileSymlinks\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*FollowFileSymlinks[[:space:]]+/--follow-file-symlinks=/'`)
EXCLUDE_PATH=(`/usr/bin/egrep -e '^[[:space:]]*ExcludePath\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*ExcludePath[[:space:]]+/--exclude=/'`)
DETECT_PUA=(`/usr/bin/egrep -e '^[[:space:]]*DetectPUA\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*DetectPUA[[:space:]]+/--detect-pua=/'`)
EXCLUDE_PUA=(`/usr/bin/egrep -e '^[[:space:]]*ExcludePUA\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*ExcludePUA[[:space:]]+/--exclude-pua=/'`)
INCLUDE_PUA=(`/usr/bin/egrep -e '^[[:space:]]*IncludePUA\b' "${CLAMD_CONF}" | /usr/bin/sed -E -e 's/^[[:space:]]*IncludePUA[[:space:]]+/--include-pua=/'`)
IFS=' '

DATE=(/bin/date "+%FT%T")
TS=`${DATE[@]}`
CLAMAVSCANIT_LOG="${HOME}/Library/Logs/ClamavScanIt/ClamavScanIt_${TS}.log"

[ -d "${CLAMAV_SERVER_QUARANTINE}" ] || /bin/mkdir -p "${CLAMAV_SERVER_QUARANTINE}"
[ -d "${CLAMAVSCANIT_LOG%/*}" ] || /bin/mkdir -p "${CLAMAVSCANIT_LOG%/*}"
echo "ClamavScanIt scanning ${EVENT[*]} on `${DATE[@]}`…" >> "${CLAMAVSCANIT_LOG}"
if [[ ! "`/usr/bin/pgrep -u root clamd`" == "" && ${EUID} -eq 0 ]]; then
	# run clamdscan as root
	/usr/bin/nice -n 5 "${prefix}/bin/clamdscan" --multiscan --quiet --fdpass --move="${CLAMAV_SERVER_QUARANTINE}" --log="${CLAMAVSCANIT_LOG}" \
		"${EVENT[@]}" \
		&& echo "Done clamdscan on `${DATE[@]}`." >> "${CLAMAVSCANIT_LOG}" \
		|| echo "clamdscan exited with error code $? on `${DATE[@]}`." >> "${CLAMAVSCANIT_LOG}" ;
else
	# run clamscan as the user
	/usr/bin/nice -n 5 "${prefix}/bin/clamscan" --infected --quiet --move="${CLAMAV_SERVER_QUARANTINE}" --log="${CLAMAVSCANIT_LOG}" \
		"${CROSS_FS[@]}" "${FOLLOW_DIR_SYMLINKS[@]}" "${FOLLOW_FILE_SYMLINKS[@]}" "${EXCLUDE_PATH[@]}" "${DETECT_PUA[@]}" "${EXCLUDE_PUA[@]}" "${INCLUDE_PUA[@]}" \
		"${EVENT[@]}" \
		&& echo "Done clamscan on `${DATE[@]}`." >> "${CLAMAVSCANIT_LOG}" \
		|| echo "clamscan exited with error code $? on `${DATE[@]}`." >> "${CLAMAVSCANIT_LOG}" ;
fi

# Quarantine notification
if [ "$((`/usr/bin/egrep -A8 -e '^----------- SCAN SUMMARY -----------$' "${CLAMAVSCANIT_LOG}" | /usr/bin/tail -n 9 | /usr/bin/grep Infected | /usr/bin/grep -v 0 | /usr/bin/wc -l`+0))" -gt 0 ]; then
	IFS=$'\n';
	FOUND=(`/usr/bin/egrep -E -e '.+:[[:space:]]+.+[[:space:]]+FOUND' "${CLAMAVSCANIT_LOG}"`)
	K=$((0))
	KMAX=$((5))
	for V in ${FOUND[@]}; do
		F=${V%: *}
		SIG=${V% FOUND}
		SIG=${SIG##*: }
		if [ $K -lt $KMAX ]; then
			/bin/cat <<VIRUSDETECTION
Virus Detection '${SIG}' in '${F}';
	moved to ${CLAMAV_SERVER_QUARANTINE}.
VIRUSDETECTION
			if [ $K -gt 0 ]; then
				# Let notifications and sounds catch up
				/bin/sleep 1
			fi
			export VNOTIFICATION="Virus Detection '${SIG}' in '${F}'"
			export VTITLE="ClamavScanIt Virus Detection"
			export VSUBTITLE="File Quarantined to ${CLAMAV_SERVER_QUARANTINE}"
		        export VSOUND=Submarine
			/usr/bin/osascript -e \
				'display notification (system attribute "VNOTIFICATION") sound name (system attribute "VSOUND") with title (system attribute "VTITLE") subtitle (system attribute "VSUBTITLE")'
		else
			/bin/cat <<MOREVDETECTIONS
Additional Virus Detections and Quarantined Files…
	please see ${CLAMAVSCANIT_LOG}.
MOREVDETECTIONS
			export VNOTIFICATION="Additional Virus Detections and Quarantined Files…"
			export VTITLE="ClamavScanIt Virus Detections"
			export VSUBTITLE="Please see ${CLAMAVSCANIT_LOG}"
			export VSOUND=Purr
			/usr/bin/osascript -e \
				'display notification (system attribute "VNOTIFICATION") sound name (system attribute "VSOUND") with title (system attribute "VTITLE") subtitle (system attribute "VSUBTITLE")'
			break
		fi
		((K++))
	done
	exit 1
else
	export VNOTIFICATION="No Virus Signature Detected"
	export VTITLE="ClamavScanIt Report"
	export VSOUND=Hero
	/usr/bin/osascript -e \
		'display notification (system attribute "VNOTIFICATION") sound name (system attribute "VSOUND") with title (system attribute "VTITLE")'
	exit 0
fi
