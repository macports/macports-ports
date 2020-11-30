#!/bin/sh

# macOS-Fortress: Firewall, Blackhole, and Privatizing Proxy
# for Trackers, Attackers, Malware, Adware, and Spammers

# macos_fortress_setup_check.sh

# commands

SUDO=/usr/bin/sudo
PORT=/opt/local/bin/port
LAUNCHCTL=/bin/launchctl
PFCTL=/sbin/pfctl
KILLALL=/usr/bin/killall
CAT=/bin/cat
SED=/usr/bin/sed
GREP=/usr/bin/grep
EGREP=/usr/bin/egrep
ECHO=/bin/echo
PFCTL=/sbin/pfctl
HEAD=/usr/bin/head
TAIL=/usr/bin/tail
LSOF=/usr/sbin/lsof
KILLALL=/usr/bin/killall
PS=/bin/ps
WC=/usr/bin/wc
CURL=/usr/bin/curl
AWK=/usr/bin/awk
HOSTNAME=/bin/hostname

JSC=/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Helpers/jsc

PROXY_HOSTNAME="${PROXY_HOSTNAME:-@PROXY_HOSTNAME@}"
LAUNCHDAEMONS=/Library/LaunchDaemons
# apache for proxy.pac
if ! [ -d /Applications/Server.app ]
then
    # macOS native apache server for proxy.pac
    PROXY_PAC_DIRECTORY="${PROXY_PAC_DIRECTORY:-@PROXY_PAC_DIRECTORY@}"
else
    # macOS Server for proxy.pac
    PROXY_PAC_DIRECTORY="${PROXY_PAC_DIRECTORY:-/Library/WebServer/Sites/${PROXY_HOSTNAME}}"
fi

fname_exists () { [ -f "${FNAME}" ] && echo "[✅] ${FNAME} exists" || echo "[❌] ${FNAME} DOESN'T EXIST!"; }

# print launchd status, or echo "# comment line"
launchctl_check () { "${EGREP}" -q -e '^(\d+|-)+\s[0]' <<< "${LINE}" && echo "[✅]\t${LINE}" || echo "[❌]\t${LINE}"; }

# launchctl_check () { [ "${PLIST##\#*}" == "" ] && echo "${PLIST}" || ( [ -f "${LAUNCHDAEMONS}/${PLIST}" ] && ( LINE=`"${SUDO}" "${LAUNCHCTL}" list | "${EGREP}" -e $(echo "${PLIST}" | "${SED}" -e 's/.plist$//')'$'`; "${EGREP}" -q -e '^(\d+|-)+\s[0]' <<< "${LINE}" && echo "[✅] ${LINE}" || "[❌] ${LINE}" ) || echo "[❌] ${LAUNCHDAEMONS}/${PLIST}: NOT INSTALLED!"; ) }

"${CAT}" <<HELPSTRING
Checking macOS-Fortress installed items (run as sudo)…
HELPSTRING

# launchcd.plist
"${CAT}" <<EOF

Checking launchd.plist files…
EOF

LAUNCHD_PLISTS=( \
        org.macports.@NAME@ \
        org.macports.@NAME@-pf \
        org.macports.@NAME@-pf.brutexpire \
        org.macports.@NAME@-pf.subports \
        org.macports.@NAME@-dshield \
        org.macports.@NAME@-emergingthreats \
        org.macports.@NAME@-proxy \
        org.macports.@NAME@-proxy.squid-rotate \
        org.macports.@NAME@-easylistpac \
        org.macports.@NAME@-hosts \
        org.macports.adblock2privoxy \
        org.macports.adblock2privoxy-nginx \
        org.macports.Squid \
        org.macports.Privoxy \
    )

for PLIST in "${LAUNCHD_PLISTS[@]}" \
	; do \
	FNAME="${LAUNCHDAEMONS}/${PLIST}.plist"; \
	fname_exists; \
done

"${CAT}" <<'EOF'

Checking launchd.plist's. These should all be installed with return
code 0 (2d column of `sudo launchctl list`)…
EOF

IFS="|"
LAUNCHD_PLISTS_REGEX="(${LAUNCHD_PLISTS[*]%%.plist})"
IFS=$'\n'
LAUNCHD_LIST=(`"${SUDO}" "${LAUNCHCTL}" list | "${EGREP}" "${LAUNCHD_PLISTS_REGEX}"`)

# loaded launchcd.plist's
for LINE in "${LAUNCHD_LIST[@]}" \
	; do \
	launchctl_check; \
done
# unloaded launchcd.plist's
LAUNCHD_SERVICES=(`for L in "${LAUNCHD_LIST[@]}"; do "${AWK}" '{ print $3 }' <<< "${L}"; done`)
IFS="|"
LAUNCHD_SERVICES_REGEX="(${LAUNCHD_SERVICES[*]})"
IFS=$'\n'
for SERVICE in "${LAUNCHD_PLISTS[@]}" \
	; do \
	"${EGREP}" -q -e "${LAUNCHD_SERVICES_REGEX}" <<< "${SERVICE%%.plist}" \
	|| echo "[❌] ${SERVICE%%.plist} isn't loaded!"; \
done

# PF
"${CAT}" <<EOF

Checking PF files…
EOF

unset IFS
PF_FILES=( \
	@PREFIX@/etc/@NAME@/pf.conf \
	@PREFIX@/etc/@NAME@/blockips.conf \
        @PREFIX@/etc/@NAME@/emerging-Block-IPs.txt \
        @PREFIX@/etc/@NAME@/compromised-ips.txt \
        @PREFIX@/etc/@NAME@/dshield_block_ip.txt \
	@PREFIX@/etc/@NAME@/block.txt \
	@PREFIX@/etc/@NAME@/block.txt.asc \
) 
for FNAME in "${PF_FILES[@]}" \
	; do \
	fname_exists; \
done

"${CAT}" <<EOF

Checking PF…
EOF

# pfctl
if [[ `"${SUDO}" "${PFCTL}" -s info | "${HEAD}" -1 | "${TAIL}" -1` =~ "Status: Enabled" ]]; then
    echo "[✅] PF is enabled and running"
else
    "${CAT}" <<EOF
[❌] PF isn't enabled! Troubleshooting:

sudo pfctl -si
less @PREFIX@/var/log/@NAME@.log
sudo @PREFIX@/bin/gpg --homedir /var/root/.gnupg --list-keys | grep -A2 -B1 -i dshield.org
sudo pfctl -Fall && sudo pfctl -ef @PREFIX@/etc/@NAME@/pf.conf
EOF
fi

# hosts
"${CAT}" <<EOF

Checking hosts files…
EOF

HOSTS_FILES=( \
	@PREFIX@/etc/@NAME@/@NAME@-hosts \
	@PREFIX@/etc/@NAME@/whitelist.txt \
	@PREFIX@/etc/@NAME@/blacklist.txt \
)

for FNAME in "${HOSTS_FILES[@]}" \
	; do \
	fname_exists; \
done

"${CAT}" <<EOF

Checking @PREFIX@/etc/@NAME@/@NAME@-hosts creation…
EOF

# pfctl
if [ -f @PREFIX@/etc/@NAME@/@NAME@-hosts ]; then
    echo "[✅] @PREFIX@/etc/@NAME@/@NAME@-hosts exists"
else
    "${CAT}" <<EOF
[❌] @PREFIX@/etc/@NAME@/@NAME@-hosts doesn't exist! Troubleshooting:

sudo port reload org.macports.@NAME@-hosts
sudo launchctl kickstart -k system/org.macports.@NAME@-hosts
EOF
fi

# Proxy PAC and proxy chain
"${CAT}" <<EOF

Checking proxy PAC and proxy chain files…
EOF

PROXY_FILES=( \
	"${PROXY_PAC_DIRECTORY}/proxy.pac.orig" \
	"${PROXY_PAC_DIRECTORY}/proxy.pac" \
	@PREFIX@/bin/easylist_pac.py \
	@PREFIX@/bin/adblock2privoxy \
        @PREFIX@/etc/@NAME@/proxy.pac \
	@PREFIX@/etc/adblock2privoxy/nginx.conf \
        @PREFIX@/etc/adblock2privoxy/css/default.html \
        @PREFIX@/etc/adblock2privoxy/privoxy/ab2p.action \
        @PREFIX@/etc/adblock2privoxy/privoxy/ab2p.filter \
        @PREFIX@/etc/adblock2privoxy/privoxy/ab2p.system.action \
        @PREFIX@/etc/adblock2privoxy/privoxy/ab2p.system.filter \
        @PREFIX@/etc/squid/squid.conf \
        @PREFIX@/var/squid/logs/cache.log \
        @PREFIX@/etc/privoxy/config \
        @PREFIX@/var/log/privoxy/logfile \
)

for FNAME in "${PROXY_FILES[@]}" \
	; do \
	fname_exists; \
done

"${CAT}" <<EOF

Checking proxy status…
EOF

# squid
if [[ `"${SUDO}" "${LSOF}" -i ':3128' | "${TAIL}" -1` && `"${PS}" -ef | "${GREP}" "@PREFIX@/sbin/squid -s" | "${EGREP}" -v '(grep|daemondo)' | "${WC}" -l` -eq 1 ]]; then
    echo "[✅] Squid is running properly"
else
    "${CAT}" <<EOF
[❌] Squid isn't running properly! Troubleshooting:

sudo squid -k check
sudo less @PREFIX@/var/squid/logs/cache.log
sudo port unload squid4
sudo killall '(squid-1)'
sudo killall 'squid'
sleep 5
sudo port load squid4
EOF
fi

# privoxy
if [[ `"${SUDO}" "${LSOF}" -i ':8118' | "${TAIL}" -1` ]]; then
    echo "[✅] Privoxy is running properly"
else
    "${CAT}" <<EOF
[❌] Privoxy isn't running properly! Troubleshooting:

sudo less @PREFIX@/var/log/privoxy/logfile
sudo port reload privoxy
EOF
fi

# Privoxy configuration http://p.p/ via proxy server
if [[ `( http_proxy=http://${PROXY_HOSTNAME}:3128; "${CURL}" -s --head http://p.p/ | "${HEAD}" -n 1 | "${GREP}" "HTTP/1.\d [23]\d\d" )` ]]; then
    echo "[✅] Privoxy config http://p.p/ via http://${PROXY_HOSTNAME}:3128 is running properly"
else
    "${CAT}" <<EOF
[❌] Privoxy config http://p.p/ via http://${PROXY_HOSTNAME}:3128 isn't running properly! Troubleshooting:

sudo less @PREFIX@/var/log/privoxy/logfile
sudo port reload privoxy
EOF
fi

# nginx
if [[ `"${SUDO}" "${LSOF}" -i ':8119' | "${TAIL}" -1` ]]; then
    echo "[✅] nginx is running properly"
else
    "${CAT}" <<'EOF'
[❌] nginx isn't running properly! Troubleshooting:

sudo ps -f `cat @PREFIX@/var/run/nginx/nginx-adblock2privoxy.pid`
sudo port reload org.macports.adblock2privoxy-nginx
EOF
fi

# Javascript parsing of proxy.pac.orig and proxy.pac
if [ -x "${JSC}" -a -f "${PROXY_PAC_DIRECTORY/proxy.pac.orig}" ]; then \
    "${JSC}" "${PROXY_PAC_DIRECTORY}/proxy.pac.orig" >/dev/null 2>&1 \
	&& echo "[✅] PAC ${PROXY_PAC_DIRECTORY}/proxy.pac.orig passes Javascript parsing" \
	|| echo "[❌] PAC ${PROXY_PAC_DIRECTORY}/proxy.pac.orig fails Javascript parsing" ; \
fi
if [ -x "${JSC}" -a -f "${PROXY_PAC_DIRECTORY}/proxy.pac" ]; then \
    "${JSC}" "${PROXY_PAC_DIRECTORY}/proxy.pac" >/dev/null 2>&1 \
	&& echo "[✅] PAC ${PROXY_PAC_DIRECTORY}/proxy.pac passes Javascript parsing" \
	|| echo "[❌] PAC ${PROXY_PAC_DIRECTORY}/proxy.pac fails Javascript parsing" ; \
fi

# proxy.pac on proxy server
if [[ `"${CURL}" -s --head "http://${PROXY_HOSTNAME}/proxy.pac" | "${HEAD}" -n 1 | "${GREP}" "HTTP/1.\d [23]\d\d"` ]]; then
    echo "[✅] Web server for http://${PROXY_HOSTNAME}/proxy.pac is running properly"
else
    "${CAT}" <<EOF
[❌] Web server for http://${PROXY_HOSTNAME}/proxy.pac isn't running properly! Troubleshooting:

sudo apachectl start
EOF
fi

# blackhole on proxy server
if [[ `"${CURL}" -s --head "http://${PROXY_HOSTNAME}:8119/" | "${HEAD}" -n 1 | "${GREP}" "HTTP/1.[01] [23]\d\d"` ]]; then
    echo "[✅] Blackhole server for http://${PROXY_HOSTNAME}:8119/ is running properly"
else
    "${CAT}" <<EOF
[❌] Blackhole server for http://${PROXY_HOSTNAME}:8119/ isn't running properly! Troubleshooting:

sudo ps -f \`cat @PREFIX@/var/run/nginx/nginx-adblock2privoxy.pid\`
sudo port reload org.macports.adblock2privoxy-nginx
EOF
fi
